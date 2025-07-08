resource "google_cloud_scheduler_job" "sql_export_schedule" {
  name        = var.sql_export_nm
  description = "Scheduled SQL Export Job"
  schedule    = var.schedule  # 예: "0 2 * * *" → 매일 2시
  time_zone   = "Asia/Seoul"

  http_target {
    http_method = "POST"
    uri         = var.func_url  # Function URL
    body        = base64encode("{}")  # 필요하면 메시지 전달 가능

    oidc_token {
      service_account_email = var.sql_exp_sa_email
    }
  }
}
