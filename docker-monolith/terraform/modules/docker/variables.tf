variable public_key_path {
  description = "Path to the public key used to connect to instance"
}

variable private_key_path {
  description = "Path to the public key used to connect to instance"
}

variable zone {
  description = "Zone"
}

variable docker_disk_image {
  description = "Disk image for docker host"
  default     = "docker-host"
}

variable "puma_port" {
  description = "TCP port that puma server listen's"
  default     = ["9292"]
}

variable "source_range" {
  type        = "list"
  description = "allow access from this addresses"
}

variable "puma_env" {
  description = "Path to env file for systemd puma unit"
  default     = "/tmp/puma.env"
}

variable "docker_provision_status" {
  description = "enable or disable provision scripts"
  default     = "false"
}
