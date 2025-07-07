
resource "google_compute_network" "main" {
  name                    = var.vpc_nm
  auto_create_subnetworks = false
  routing_mode            = "REGIONAL"
}

resource "google_compute_subnetwork" "main_subnet" {
  name          = var.snet_nm
  ip_cidr_range = var.snet_ip_cidr
  region        = var.region
  network       = google_compute_network.main.id

  secondary_ip_range {
    range_name    = var.pods_range_nm
    ip_cidr_range = var.gke_pod_cidr
  }

  secondary_ip_range {
    range_name    = var.svc_range_nm
    ip_cidr_range = var.gke_svc_cidr
  }
}

resource "google_compute_global_address" "private_ip_addr" {
  name          = var.vpc_ip_range_nm
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  address       = var.db_ip_cidr
  network       = google_compute_network.main.id
}

resource "google_service_networking_connection" "private_vpc_conn" {
  network                 = google_compute_network.main.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_addr.name]

  depends_on = [
    google_compute_global_address.private_ip_addr
  ]

}

# 1. Cloud Router 생성
resource "google_compute_router" "nat_router" {
  name    = var.router_nm
  network = google_compute_network.main.name
  region  = var.region
}

# 2. NAT Gateway 생성
resource "google_compute_router_nat" "nat_gateway" {
  name                               = var.nat_nm
  router                             = google_compute_router.nat_router.name
  region                             = var.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  enable_endpoint_independent_mapping = true

  log_config {
    enable = true
    filter = "ALL"
  }
}

resource "google_vpc_access_connector" "vpc_connector" {
  name          = var.vpc_connector_nm
  region        = var.region
  network       = google_compute_network.main.name
  ip_cidr_range = var.vpc_conn_cidr

  min_throughput = 200
  max_throughput = 300
  machine_type   = "e2-micro"
}
