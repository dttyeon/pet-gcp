resource "google_cloud_scheduler_job" "sql_export_schedule" {
  name        = var.sql_export_nm
  description = "Scheduled SQL Export Job"
  schedule    = var.schedule  # 예: "0 2 * * *" → 매일 2시
  time_zone   = "Asia/Seoul"

  http_target {
    http_method = "POST"
    uri         = var.func_url
    body        = base64encode("{}")  # 필요하면 메시지 전달 가능

    oidc_token {
      service_account_email = var.sql_exp_sa_email
      audience              = var.func_url
    }
  }
}

resource "google_service_account" "scheduler_sa" {
  account_id   = "cloud-scheduler-sa"
  display_name = "Cloud Scheduler Service Account"
}

resource "google_project_iam_member" "scheduler_run_invoker" {
  project = "581752627401"
  role    = "roles/run.invoker"
  member  = "serviceAccount:${google_service_account.scheduler_sa.email}"
}

