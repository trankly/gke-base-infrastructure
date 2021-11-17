variable "project_id" {
  type = string
}

variable "region" {
  type = string
}

variable "gke_master_ipv4_cidr_block" {
  type    = string
  default = "172.23.0.0/28"
}

variable "authorized_source_ranges" {
  type        = list(string)
  description = "Addresses or CIDR blocks which are allowed to connect to GKE API Server."
}

variable "network_name" {
  type = string
}

variable "subnetwork_id" {
  type = string
}