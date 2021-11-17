resource "google_compute_global_address" "private_ip_peering" {
  name          = "google-managed-services-custom-redis"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 24
  network       = var.network_id
  project       = var.project_id
}

resource "google_service_networking_connection" "private_vpc_connection" {
  network = var.network_id
  service = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [
    google_compute_global_address.private_ip_peering.name
  ]
}

resource "google_redis_instance" "redis" {
  memory_size_gb     = var.redis_size
  name               = "${var.environment}-${var.suffix}"
  authorized_network = var.network_id
  connect_mode       = "PRIVATE_SERVICE_ACCESS"
  project            = var.project_id
  provider           = google
  depends_on = [
    google_service_networking_connection.private_vpc_connection
  ]
}
