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

resource "google_storage_bucket_iam_member" "sql_export_bucket_access" {
  bucket = var.export_bucket
  role   = "roles/storage.admin"
  member = "serviceAccount:${google_service_account.cf_sql_export_sa.email}"
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
        object = var.dump_source_archive
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
/*
resource "google_cloudfunctions2_function" "gcs_to_s3" {
  name        = "gcs-to-s3-transfer"
  location    = var.region
  project     = var.project_id
  build_config {
    runtime     = "python312"
    entry_point = "transfer_to_s3"
    source {
      storage_source {
        bucket = var.export_bucket
        object = var.tran_source_archive
      }
    }
  }

  service_config {
    environment_variables = {
      SECRET_ID = google_secret_manager_secret.aws_credentials.id
    }
    ingress_settings = "ALLOW_ALL"
  }

  event_trigger {
    event_type = "google.cloud.storage.object.v1.finalized"
    retry_policy = "RETRY_POLICY_RETRY"
    service_account_email = google_service_account.cf_gcs_to_s3_sa.email
    event_filters {
      attribute = "bucket"
      value = "ayvet-dev-gcs-bu"
    }
  }
}

*/
resource "google_cloudfunctions2_function_iam_member" "invoker" {
  project        = var.project_id
  cloud_function = google_cloudfunctions2_function.sql_export.name
  role           = "roles/cloudfunctions.invoker"
  member         = "serviceAccount:${var.sche_email}"
}

/*
resource "google_service_account" "cf_gcs_to_s3_sa" {
  account_id   = "cf-gcs-to-s3-sa"
  display_name = "Cloud Function GCS to S3 Transfer Service Account"
}

resource "google_project_iam_member" "cf_gcs_to_s3_roles" {
  for_each = toset([
    "roles/secretmanager.secretAccessor",  
    "roles/storage.objectViewer",          
    "roles/eventarc.eventReceiver",
    "roles/pubsub.publisher"
  ])

  project = var.project_id
  role    = each.value
  member  = "serviceAccount:${google_service_account.cf_gcs_to_s3_sa.email}"
}

resource "google_project_iam_member" "eventarc_bucket_access" {
  project = var.project_id
  role    = "roles/storage.admin"
  member  = "serviceAccount:service-581752627401@gcp-sa-eventarc.iam.gserviceaccount.com"
}

resource "google_storage_bucket_iam_member" "cloud_sql_instance_bucket_access" {
  bucket = var.export_bucket
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:service-581752627401@gcp-sa-cloud-sql.iam.gserviceaccount.com"
}
*/