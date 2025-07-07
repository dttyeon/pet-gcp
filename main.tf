#$env:GOOGLE_APPLICATION_CREDENTIALS = "C:\Users\user\Downloads\kdt1-finalproject-0e8927005a17.json"

provider "google" {
  project = var.project_id
  region  = var.region
}

data "google_container_cluster" "cluster" {
  name       = module.gke.gke_cluster_name
  location   = var.region
  depends_on = [module.gke]
}

data "google_client_config" "default" {
  depends_on = [module.gke]
}

provider "kubernetes" {
  host                   = data.google_container_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.google_container_cluster.cluster.master_auth[0].cluster_ca_certificate)
  token                  = data.google_client_config.default.access_token
}

provider "helm" {
  kubernetes = {
    host                   = data.google_container_cluster.cluster.endpoint
    cluster_ca_certificate = base64decode(data.google_container_cluster.cluster.master_auth[0].cluster_ca_certificate)
    token                  = data.google_client_config.default.access_token
  }
}

module "vpc" {
  source = "./modules/vpc"

  region           = var.region
  vpc_connector_nm = "${local.name_prefix}-vc"
  vpc_ip_range_nm  = "${local.name_prefix}-ipr"
  vpc_nm           = "${local.name_prefix}-vpc"
  nat_nm           = "${local.name_prefix}-nat"
  router_nm        = "${local.name_prefix}-routr"
  snet_nm          = "${local.name_prefix}-snet"
  pods_range_nm    = var.pods_range_nm
  svc_range_nm     = var.svc_range_nm

  #output 값
  db = module.rds.db
}

module "rds" {
  source = "./modules/rds"

  region      = var.region
  name_prefix = local.name_prefix
  db_pw       = var.db_pw
  db_version  = var.db_version

  #output 값
  vpc_conn = module.vpc.private_vpc_conn
  vpc      = module.vpc.vpc
}

module "vm" {
  source = "./modules/vm"

  region = var.region

  #output 값
  db_ip   = module.rds.db_ip
  vpc_id  = module.vpc.vpc.id
  snet_id = module.vpc.snet.id
  nlb_ip  = module.lb.nlb_ip

  depends_on = [module.rds]
}

module "lb" {
  source = "./modules/lb"

  region      = var.region
  nlb_nm      = "${local.name_prefix}-nlb"
  alb_nm      = "${local.name_prefix}-alb"
  nlb_ip_nm   = "${local.name_prefix}-nlb-ip"
  nlb_rule_nm = "${local.name_prefix}-nlb-rule"
  alb_ip_nm   = "${local.name_prefix}-alb-ip"

  #output 값
  vpc_id  = module.vpc.vpc.id
  snet_id = module.vpc.snet.id
  web_mig = module.vm.web_mig
  was_mig = module.vm.was_mig
}

module "dns" {
  source = "./modules/dns"
  dns_nm = "${local.name_prefix}-dns"

  #output 값
  alb_ip = module.lb.alb_ip
}

module "gke" {
  source = "./modules/gke"

  region                     = var.region
  name_prefix                = local.name_prefix
  cluster_nm                 = "${local.name_prefix}-clustr"
  cluster_secondary_range_nm = var.pods_range_nm
  svc_secondary_range_nm     = var.svc_range_nm

  #output 값
  ay_snet        = module.vpc.snet
  ay_vpc         = module.vpc.vpc
  vpc_connection = module.vpc
}

module "workload_identity" {
  source         = "./modules/workload_identity"
  project_id     = var.project_id
  gsa_account_id = "${local.name_prefix}-gsa"
  ksa_name       = "${local.name_prefix}-ksa"
  namespace      = "default"
  roles          = "roles/storage.admin"
}

module "argoCD" {
  source      = "./modules/argoCD"
  name_prefix = local.name_prefix
  argo_nm     = "${local.name_prefix}-argocd"

  depends_on = [module.gke]
}

module "cloudRun" {
  source = "./modules/cloudRun"
  region = var.region
  run_job_sa_nm = "${local.name_prefix}-rjb-sa"
  dump_job_nm = "${local.name_prefix}-my-dump"

  instance_connection_name = module.rds.db.connection_name
}