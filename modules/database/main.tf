resource "google_sql_database_instance" "postgresql" {
  name             = "${var.environment}-${var.suffix}"
  region           = var.region
  database_version = var.database_version
  settings {
    availability_type = var.availability_type
    tier              = var.machine_type
    disk_size         = var.disk_size
    ip_configuration {
      ipv4_enabled    = false
      private_network = var.network_id
    }
    backup_configuration {
      enabled    = true
      start_time = "06:00"
    }
  }
  depends_on = [
    google_service_networking_connection.private_vpc_connection
  ]
  project = var.project_id
}

resource "random_password" "db-password" {
  length           = 16
  special          = true
  override_special = "_%@"
}

resource "google_secret_manager_secret" "db-password" {
  secret_id = "db-password-${var.environment}"
  labels = {
    label = "db-password-${var.environment}"
  }
  replication {
    user_managed {
      replicas {
        location = var.region
      }
    }
  }
  project  = var.project_id
  provider = google
}

resource "google_secret_manager_secret_version" "secret-version-basic" {
  secret      = google_secret_manager_secret.db-password.id
  secret_data = random_password.db-password.result
  provider    = google
}

resource "google_sql_database" "admin" {
  name     = "admin"
  instance = google_sql_database_instance.postgresql.name
  project  = var.project_id
}

resource "google_sql_user" "admin" {
  name     = "admin"
  instance = google_sql_database_instance.postgresql.name
  password = google_secret_manager_secret_version.secret-version-basic.secret_data
  project  = var.project_id
}

resource "google_compute_global_address" "private_ip_peering" {
  name          = "google-managed-services-custom-database"
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

