provider "google" {
  version = "1.4.0"
  project = "${var.project}"
  region  = "${var.region}"
}

resource "google_compute_project_metadata" "default" {
  metadata {
    ssh-keys = "appuser:${file(var.public_key_path)}"
  }
}

resource "google_compute_instance_template" "instance_template" {
  name         = "reddit-full-template"
  tags         = ["reddit-app"]
  machine_type = "g1-small"

  scheduling = {
    automatic_restart = "true"
  }

  disk {
    source_image = "reddit-full"
  }

  network_interface {
    network       = "default"
    access_config = {}
  }
}

resource "google_compute_target_pool" "pool" {
  name    = "pool"
  project = "${var.project}"
  region  = "${var.region}"
}

resource "google_compute_instance_group_manager" "instance-group-manager" {
  name               = "instance-group-manager"
  instance_template  = "${google_compute_instance_template.instance_template.self_link}"
  base_instance_name = "instance-group-manager"
  target_pools       = ["${google_compute_target_pool.pool.self_link}"]
  target_size        = "2"
  zone               = "${var.zone}"
}

resource "google_compute_forwarding_rule" "default" {
  project               = "${var.project}"
  name                  = "fw"
  target                = "${google_compute_target_pool.pool.self_link}"
  load_balancing_scheme = "EXTERNAL"
  port_range            = "80"
}

resource "google_compute_firewall" "firewall_puma" {
  name    = "allow-puma-default"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["9292"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["reddit-app"]
}
