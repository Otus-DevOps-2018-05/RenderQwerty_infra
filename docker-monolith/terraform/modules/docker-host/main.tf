resource "google_compute_instance" "docker-host" {
  name         = "docker-host"
  machine_type = "g1-small"
  zone         = "${var.zone}"
  tags         = ["docker-host"]

  metadata {
    ssh-key = "appuser:${file(var.public_key_path)}"
  }

  boot_disk {
    initialize_params {
      image = "${var.docker-host_disk_image}"
    }
  }

  network_interface {
    network = "default"

    access_config = {
      nat_ip = "${google_compute_address.docker-host_ip.address}"
    }
  }
}

resource "null_resource" "docker-host" {
  count = "${var.docker-host_provision_status ? 1 : 0}"

  connection {
    host        = "${google_compute_instance.docker-host.network_interface.0.access_config.0.assigned_nat_ip}"
    type        = "ssh"
    user        = "appuser"
    agent       = "false"
    private_key = "${file(var.private_key_path)}"
  }

  resource "google_compute_address" "docker-host_ip" {
    name = "docker-host-ip"
  }

  resource "google_compute_firewall" "firewall_puma" {
    name    = "allow-puma-default"
    network = "default"

    allow {
      protocol = "tcp"
      ports    = ["${var.puma_port}", "80"]
    }

    source_ranges = ["${var.source_range}"]
    target_tags   = ["docker-host"]
  }
}
