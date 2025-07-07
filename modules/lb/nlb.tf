resource "google_compute_address" "nlb_ip" {
  name         = var.nlb_ip_nm
  address_type = "INTERNAL"
  subnetwork   = var.snet_id
  region       = var.region
}

resource "google_compute_forwarding_rule" "ilb" {
  name                  = var.nlb_rule_nm
  region                = var.region
  load_balancing_scheme = "INTERNAL"
  ip_protocol           = "TCP"
  ports                 = ["8080"]
  backend_service       = google_compute_region_backend_service.ilb_backend.id
  subnetwork            = var.snet_id
  network               = var.vpc_id
  ip_address            = google_compute_address.nlb_ip.address
}

resource "google_compute_region_backend_service" "ilb_backend" {
  name                  = var.nlb_nm
  region                = var.region
  protocol              = "TCP"
  load_balancing_scheme = "INTERNAL"
  health_checks         = [google_compute_health_check.was_tcp.id]

  backend {
    group          = var.was_mig
    balancing_mode = "CONNECTION"
  }
}


resource "google_compute_health_check" "was_tcp" {
  name = "tcp-health"
  tcp_health_check {
    port = 8080
  }
}