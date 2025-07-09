resource "google_storage_bucket" "backup" {
  name     = var.gcs_bck_nm
  location = var.region
  force_destroy = false  # 삭제 시 객체 남기지 않게 (보통 false로 둬)
  storage_class = "STANDARD"

  lifecycle_rule {
    action {
      type = "Delete"
    }
    condition {
      age = 30  # 30일 지난 객체 자동 삭제 (선택)
    }
  }

  lifecycle {
    prevent_destroy = false
  }
}

resource "google_project_iam_member" "gcs_service_account_pubsub" {
  project = "581752627401"
  role    = "roles/pubsub.publisher"
  member  = "serviceAccount:service-581752627401@gs-project-accounts.iam.gserviceaccount.com"
}
