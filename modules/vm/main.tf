resource "google_compute_instance_template" "was_template" {
  name         = "ay-was-tmpl"
  machine_type = var.vm_type
  region       = var.region
  tags         = ["was"]

  disk {
    boot         = true
    auto_delete  = true
    source_image = "${var.img_path}ay-was-img"
  }

  network_interface {
    network    = var.vpc_id
    subnetwork = var.snet_id
  }
  metadata_startup_script = templatefile("${path.module}/was_startup.tftpl", {
    DB_IP = var.db_ip
    CONF  = "/opt/tomcat/latest/webapps/ROOT/WEB-INF/classes/application.properties"
  })
}

resource "google_compute_instance_group_manager" "was_mig" {
  name               = "ay-was-mig"
  base_instance_name = "ay-was"
  zone               = var.zone
  version {
    instance_template = google_compute_instance_template.was_template.self_link
  }

  target_size = 1

  named_port {
    name = "tcp8080"
    port = 8080
  }
}

resource "google_compute_instance_template" "web_template" {
  name         = "ay-web-tmpl"
  machine_type = var.vm_type
  tags         = ["web"]

  disk {
    auto_delete  = true
    boot         = true
    source_image = "${var.img_path}ay-web-img"
  }

  network_interface {
    network    = var.vpc_id
    subnetwork = var.snet_id
    access_config {}
  }

  metadata_startup_script = templatefile("${path.module}/web_startup.tftpl", {
    NEW_IP = "${var.nlb_ip}:8080/"
    OLD_IP = "10.10.0.4:8080/"
  })
}

resource "google_compute_instance_group_manager" "web_mig" {
  name = "ay-web-mig"
  zone = var.zone
  version {
    instance_template = google_compute_instance_template.web_template.self_link
  }
  base_instance_name = "ay-web"
  target_size        = 1

  named_port {
    name = "http"
    port = 80
  }
}
