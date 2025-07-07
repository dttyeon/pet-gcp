resource "google_service_account" "run_job_sa" {
  account_id   = var.run_job_sa_nm
  display_name = "Cloud Run Job Service Account"
}

resource "google_cloud_run_v2_job" "mysql_dump_job" {
  name     = var.run_job_sa_nm
  location = var.region

  template {
    template {
      containers {
        image = var.container_image  # 너가 빌드한 dump 컨테이너 이미지
        # 환경변수 설정
        env {
          name  = "INSTANCE_CONNECTION_NAME"
          value = var.instance_connection_name
        }
        env {
          name  = "DB_NAME"
          value = var.db_name
        }
        env {
          name  = "DB_USER"
          value = var.db_user
        }
        env {
          name  = "DB_PASS"
          value = var.db_password
        }
      }

      # 실행 권한
      service_account = google_service_account.run_job_sa.email
    }
  }
}