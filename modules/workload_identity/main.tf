resource "google_service_account" "gsa" {
  account_id   = var.gsa_account_id
  display_name = "Workload Identity GSA"
}

resource "google_project_iam_member" "gsa_permissions" {
  project = var.project_id
  role    = var.roles
  member  = "serviceAccount:${google_service_account.gsa.email}"
}

resource "kubernetes_service_account" "ksa" {
  metadata {
    name      = var.ksa_name
    namespace = var.namespace
    annotations = {
      "iam.gke.io/gcp-service-account" = google_service_account.gsa.email
    }
  }
}

resource "google_service_account_iam_binding" "workload_identity_binding" {
  service_account_id = google_service_account.gsa.name
  role               = var.bind_wl_role

  members = [
    "serviceAccount:${var.project_id}.svc.id.goog[default/my-ksa]",
  ]
}
