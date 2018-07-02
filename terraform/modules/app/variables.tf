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