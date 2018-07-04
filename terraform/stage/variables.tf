variable "project" {
  description = "Project id"
}

variable "region" {
  description = "Region"
  default     = "europe-west1"
}

variable "zone" {
  description = "Zone"
  default     = "europe-west1-b"
}

variable "public_key_path" {
  description = "Path to the public key used for ssh access"
}

variable "private_key_path" {
  description = "Path to private ssh key for provisioners"
}

variable "disk_image" {
  description = "Disk image"
}

variable "instance_count" {
  description = "Count of app instances for load balancing"
  default     = "1"
}

variable app_disk_image {
  description = "Disk image for reddit app"
  default     = "reddit-app-base"
}

variable db_disk_image {
  description = "Disk image for reddit db"
  default     = "reddit-db-base"
}

variable "source_range" {
  description = "allow access from this ip's"
  default     = ["0.0.0.0/0"]
}

variable "app_provision_status" {
  description = "enable or disable provision scripts"
  default     = "true"
}
