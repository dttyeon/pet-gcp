resource "google_service_account" "cf_sql_export_sa" {
  account_id   = var.sql_exp_sa_nm
  display_name = "Cloud Function SQL Export Service Account"
}

resource "google_project_iam_member" "cf_sql_export_roles" {
  for_each = toset([
    "roles/cloudsql.admin",
    "roles/storage.admin"
  ])

  project = var.project_id
  role    = each.value
  member  = "serviceAccount:${google_service_account.cf_sql_export_sa.email}"
}

resource "google_cloudfunctions2_function" "sql_export" {
  name     = var.sql_exp_nm
  location = var.region

  build_config {
    runtime     = "python311"
    entry_point = "export_sql"
    source {
      storage_source {
        bucket = var.export_bucket
        object = var.source_archive
      }
    }
  }

  service_config {
    service_account_email = google_service_account.cf_sql_export_sa.email
    environment_variables = {
      INSTANCE_ID   = var.instance_id
      EXPORT_BUCKET = var.export_bucket
      DATABASE_NAME = "petclinic"
    }
  }

}

resource "google_cloudfunctions2_function_iam_member" "invoker" {
  project        = var.project_id
  cloud_function = google_cloudfunctions2_function.sql_export.name
  role           = "roles/cloudfunctions.invoker"
  member         = "allUsers"  # 인증 없이 호출 가능 (보안 고려 시 조정)
}