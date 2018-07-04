variable public_key_path {
  description = "Path to the public key used to connect to instance"
}

variable zone {
  description = "Zone"
}

variable app_disk_image {
  description = "Disk image for reddit app"
  default     = "reddit-app-base"
}

variable "puma_port" {
  description = "TCP port that puma server listen's"
  default     = ["9292"]
}

variable "source_range" {
  description = "allow access from this addresses"
  default     = ["0.0.0.0/0"]
}

variable "private_key_path" {
  description = "Path to private ssh key for provisioners"
  default     = "~/.ssh/appuser"
}

variable "puma_env" {
  description = "Path to env file for systemd puma unit"
  default     = "/tmp/puma.env"
}

variable "db_address" {
  description = "Database internal ip"
}

variable "app_provision_status" {
  description = "enable or disable provision scripts"
  default     = "true"
}
