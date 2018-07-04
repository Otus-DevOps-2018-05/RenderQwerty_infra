variable "public_key_path" {
  description = "Path to the public key used for ssh access"
}

variable zone {
  description = "Zone"
}

variable db_disk_image {
  description = "Disk image for reddit db"
  default     = "reddit-db-base"
}

variable "mongo_port" {
  description = "TCP for for mongo database"
  default     = ["27017"]
}

variable "ssh_port" {
  description = "TCP for for mongo database"
  default     = ["22"]
}

variable "private_key_path" {
  description = "Path to private ssh key for provisioners"
  default     = "~/.ssh/appuser"
}
