resource "google_sql_database_instance" "mysql_private" {
  name             = var.rds_nm
  database_version = var.db_version
  region           = var.region

  settings {
    tier = var.db_type

    ip_configuration {
      ipv4_enabled    = false
      private_network = var.vpc.id
    }

    backup_configuration {
      enabled = true
    }

    activation_policy = "ALWAYS"
  }

  deletion_protection = false
  depends_on          = [var.vpc_conn]
}

resource "google_sql_database" "db" {
  name     = var.add_db_nm
  instance = google_sql_database_instance.mysql_private.name
}

resource "google_sql_user" "db_user" {
  name     = var.db_user_nm
  instance = google_sql_database_instance.mysql_private.name
  host     = "%"
  password = var.db_pw
}

data "google_project" "project" {
  project_id = "581752627401"
}