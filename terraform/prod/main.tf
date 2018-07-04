provider "google" {
  version = "1.4.0"
  project = "${var.project}"
  region  = "${var.region}"
}

terraform {
  backend "gcs" {
    bucket = "otus-tf-backend"
    prefix = "terraform/tfstate/prod"
  }
}

module "app" {
  source               = "../modules/app"
  public_key_path      = "${var.public_key_path}"
  zone                 = "${var.zone}"
  app_disk_image       = "${var.app_disk_image}"
  db_address           = "${module.db.db_internal_ip}"
  app_provision_status = "${var.app_provision_status}"
}

module "db" {
  source          = "../modules/db"
  public_key_path = "${var.public_key_path}"
  zone            = "${var.zone}"
  db_disk_image   = "${var.db_disk_image}"
}

module "vpc" {
  source        = "../modules/vpc"
  source_ranges = ["${var.source_range}"]
}
