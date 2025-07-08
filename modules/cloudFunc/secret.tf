resource "google_secret_manager_secret" "aws_credentials" {
  secret_id = "secret"
  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "aws_credentials_version" {
  secret      = google_secret_manager_secret.aws_credentials.id
  secret_data = jsonencode({
    AWS_ACCESS_KEY_ID     = var.aws_access_key_id
    AWS_SECRET_ACCESS_KEY = var.aws_secret_access_key
    AWS_REGION            = var.aws_region
    S3_BUCKET             = var.s3_bucket
  })
}
