resource "google_dns_managed_zone" "main" {
  name     = var.dns_nm
  dns_name = "hirundos.store."
}

resource "google_dns_record_set" "alb_a_record" {
  name         = "www.hirundos.store."
  type         = "A"
  ttl          = 300
  managed_zone = google_dns_managed_zone.main.name

  rrdatas = [
    var.alb_ip
  ]

  depends_on = [google_dns_managed_zone.main]
}
