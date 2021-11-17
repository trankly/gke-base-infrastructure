resource "google_compute_network" "custom" {
  name                    = "custom"
  auto_create_subnetworks = "false"
  routing_mode            = "GLOBAL"
  project                 = var.project_id
}

resource "google_compute_subnetwork" "web" {
  name          = "web"
  ip_cidr_range = "10.10.10.0/24"
  network       = google_compute_network.custom.id
  region        = var.region

  secondary_ip_range = [
    {
      range_name    = "services"
      ip_cidr_range = "10.10.11.0/24"
    },
    {
      range_name    = "pods"
      ip_cidr_range = "10.1.0.0/20"
    }
  ]
  private_ip_google_access = true
  project                  = var.project_id
}

resource "google_compute_subnetwork" "data" {
  name                     = "data"
  ip_cidr_range            = "10.20.10.0/24"
  network                  = google_compute_network.custom.id
  region                   = var.region
  private_ip_google_access = true
  project                  = var.project_id
}

resource "google_compute_subnetwork" "redis" {
  name                     = "redis"
  ip_cidr_range            = "10.30.10.0/24"
  network                  = google_compute_network.custom.id
  region                   = var.region
  private_ip_google_access = true
  project                  = var.project_id
}

resource "google_compute_address" "web" {
  name    = "web"
  region  = var.region
  project = var.project_id
}

resource "google_compute_router" "web" {
  name    = "web"
  network = google_compute_network.custom.id
  project = var.project_id
}

resource "google_compute_router_nat" "web" {
  name                               = "web"
  router                             = google_compute_router.web.name
  nat_ip_allocate_option             = "MANUAL_ONLY"
  nat_ips                            = [google_compute_address.web.self_link]
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"
  subnetwork {
    name                    = google_compute_subnetwork.web.id
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }
  depends_on = [google_compute_address.web]
  project    = var.project_id
}

resource "google_compute_firewall" "postgresql" {
  name    = "allow-only-gke-cluster"
  network = google_compute_network.custom.name
  allow {
    protocol = "tcp"
    ports    = ["5432", "6379"]
  }
  priority      = 1000
  source_ranges = ["10.10.10.0/24"]
  project       = var.project_id
}

resource "google_compute_firewall" "web" {
  name    = "allow-only-authorized-networks"
  network = google_compute_network.custom.name

  allow {
    protocol = "tcp"
  }
  priority      = 1000
  source_ranges = var.authorized_source_ranges
  project       = var.project_id
}

