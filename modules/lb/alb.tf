resource "google_compute_global_address" "alb_ip" {
  name         = var.alb_ip_nm
  address_type = "EXTERNAL"
}
/*
resource "google_compute_target_https_proxy" "https_proxy" {
  name             = "https-proxy"
  url_map          = google_compute_url_map.web_url_map.id
  ssl_certificates = [var.ssl-route]
}
*/

resource "google_compute_backend_service" "web_backend" {
  name                            = var.alb_nm
  protocol                        = "HTTP"
  port_name                       = "http"
  timeout_sec                     = 10
  connection_draining_timeout_sec = 0

  backend {
    group = var.web_mig
  }

  health_checks = [google_compute_health_check.http_healthcheck.id]
}

resource "google_compute_health_check" "http_healthcheck" {
  name                = "http-healthcheck"
  check_interval_sec  = 5
  timeout_sec         = 5
  healthy_threshold   = 2
  unhealthy_threshold = 2

  http_health_check {
    port         = 80
    request_path = "/"
  }
}

resource "google_compute_url_map" "web_url_map" {
  name            = var.alb_nm
  default_service = google_compute_backend_service.web_backend.id
}

resource "google_compute_target_http_proxy" "http_proxy" {
  name    = "http-proxy"
  url_map = google_compute_url_map.web_url_map.id
}

resource "google_compute_global_forwarding_rule" "http_forwarding_rule" {
  name       = "http-forwarding-rule"
  ip_address = google_compute_global_address.alb_ip.address
  port_range = "80"
  target     = google_compute_target_http_proxy.http_proxy.id
}
/*
resource "google_compute_global_forwarding_rule" "https_forwarding_rule" {
  name       = "https-forwarding-rule"
  ip_address = google_compute_global_address.alb_ip.address
  port_range = "443"
  target     = google_compute_target_https_proxy.https_proxy.id
}*/