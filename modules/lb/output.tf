output "alb_ip" {
  value = google_compute_global_address.alb_ip.address
}

output "nlb_ip" {
  value = google_compute_address.nlb_ip.address
}