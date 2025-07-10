output "func_url" {
  value = google_cloudfunctions2_function.sql_export.service_config[0].uri
}

output "sql_exp_sa_email" {
    value = google_service_account.cf_sql_export_sa.email
}
