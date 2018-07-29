provider "google" {
  version = "1.4.0"
  project = "${var.project}"
  region  = "${var.region}"
}

module "docker-host" {
  source                       = "../modules/docker-host"
  public_key_path              = "${var.public_key_path}"
  private_key_path             = "${var.private_key_path}"
  zone                         = "${var.zone}"
  source_range                 = "${var.source_range}"
  docker-host_disk_image       = "${var.docker-host_disk_image}"
  docker-host_provision_status = "${var.docker-host_provision_status}"
}

module "vpc" {
  source        = "../modules/vpc"
  source_ranges = ["${var.source_range}"]
}
