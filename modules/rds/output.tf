output "db_ip" {
  value = google_sql_database_instance.mysql_private.ip_address[0].ip_address
}

output "db" {
  value = google_sql_database_instance.mysql_private
}