resource "google_container_cluster" "primary" {
  name     = var.cluster_nm
  location = var.region

  remove_default_node_pool = true
  initial_node_count       = 1

  network             = var.ay_vpc.name
  subnetwork          = var.ay_snet.name
  deletion_protection = false

  ip_allocation_policy {
    cluster_secondary_range_name  = var.cluster_secondary_range_nm
    services_secondary_range_name = var.svc_secondary_range_nm
  }

  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = false
    master_ipv4_cidr_block  = var.master_ipv4_cidr
  }

  master_auth {
    client_certificate_config {
      issue_client_certificate = false
    }
  }

  network_policy {
    enabled  = true
    provider = "CALICO"
  }

  release_channel {
    channel = "REGULAR"
  }

  workload_identity_config {
    workload_pool = "kdt1-finalproject.svc.id.goog"
  }

  depends_on = [
    var.vpc_connection
  ]

}

resource "google_container_node_pool" "primary_nodes" {
  name     = "${var.name_prefix}-${var.nodepool_suffix}"
  location = var.region
  cluster  = google_container_cluster.primary.name

  node_config {
    machine_type = var.nodepool_vm_type
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
    labels = {
      environment = "dev"
    }

  }

  autoscaling {
    min_node_count = 1
    max_node_count = 3
  }

  management {
    auto_repair  = false
    auto_upgrade = true
  }
}

