resource "google_compute_instance" "app" {
  name         = "reddit-app"
  machine_type = "g1-small"
  zone         = "${var.zone}"
  tags         = ["reddit-app"]

  boot_disk {
    initialize_params {
      image = "${var.app_disk_image}"
    }
  }

  network_interface {
    network = "default"

    access_config = {
      nat_ip = "${google_compute_address.app_ip.address}"
    }
  }

  connection {
    type        = "ssh"
    user        = "appuser"
    agent       = "false"
    private_key = "${file(var.private_key_path)}"
  }

  provisioner "file" {
    source      = "${path.module}/files/puma.service"
    destination = "/tmp/puma.service"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo echo DATABASE_URL=${var.db_address} > ${var.puma_env}",
    ]
  }

  provisioner "remote-exec" {
    script = "${path.module}/files/deploy.sh"
  }

  metadata {
    sshKeys = "appuser:${file(var.public_key_path)}"
  }
}

resource "google_compute_address" "app_ip" {
  name = "reddit-app-ip"
}

resource "google_compute_firewall" "firewall_puma" {
  name    = "allow-puma-default"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["${var.puma_port}"]
  }

  source_ranges = ["${var.source_range}"]
  target_tags   = ["reddit-app"]
}
