output "vpc" {
  value = google_compute_network.main
}

output "snet" {
  value = google_compute_subnetwork.main_subnet
}

output "private_vpc_conn" {
  value = google_service_networking_connection.private_vpc_conn
}