resource "google_compute_firewall" "allow_iap" {
  name    = "allow-iap-ingress"
  network = google_compute_network.main.id

  direction = "INGRESS"
  priority  = 1000

  source_ranges = [var.iap_ip_range]

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  target_tags = ["web", "was"]
}

resource "google_compute_firewall" "allow_web" {
  name    = "allow-web-80"
  network = google_compute_network.main.id

  direction = "INGRESS"
  priority  = 1002

  source_ranges = ["0.0.0.0/0"]

  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }

  target_tags = ["web"]
}

resource "google_compute_firewall" "allow_was" {
  name    = "allow-was-8080"
  network = google_compute_network.main.id

  direction = "INGRESS"
  priority  = 1003

  allow {
    protocol = "tcp"
    ports    = ["8080"]
  }

  source_tags = ["web"]
  target_tags = ["was"]
}
