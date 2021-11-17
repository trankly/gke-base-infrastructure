variable "region" {
  type = string
}

variable "authorized_source_ranges" {
  type        = list(string)
  description = "Addresses or CIDR blocks which are allowed to connect to GKE API Server."
}

variable "project_id" {
  type = string
}