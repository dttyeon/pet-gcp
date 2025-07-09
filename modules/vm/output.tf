output "web_mig" {
  value = google_compute_instance_group_manager.web_mig.instance_group
}

output "was_mig" {
    value = google_compute_instance_group_manager.was_mig.instance_group
}