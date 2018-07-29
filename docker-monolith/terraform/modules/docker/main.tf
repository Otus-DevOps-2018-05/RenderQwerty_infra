resource "google_compute_instance" "docker" {
  name         = "reddit-docker"
  machine_type = "g1-small"
  zone         = "${var.zone}"
  tags         = ["reddit-docker"]

  metadata {
    ssh-keys = "appuser:${file(var.public_key_path)}"
  }

  boot_disk {
    initialize_params {
      image = "${var.docker_disk_image}"
    }
  }

  network_interface {
    network = "default"

    access_config = {
      nat_ip = "${google_compute_address.docker_ip.address}"
    }
  }
}

resource "null_resource" "docker" {
  count = "${var.docker_provision_status ? 1 : 0}"

  connection {
    host        = "${google_compute_instance.docker.network_interface.0.access_config.0.assigned_nat_ip}"
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
    script = "${path.module}/files/deploy.sh"
  }
}

resource "google_compute_address" "docker_ip" {
  name = "reddit-docker-ip"
}

resource "google_compute_firewall" "firewall_puma" {
  name    = "allow-puma-default"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["${var.puma_port}", "80"]
  }

  source_ranges = ["${var.source_range}"]
  target_tags   = ["reddit-docker"]
}
