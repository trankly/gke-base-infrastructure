resource "google_container_cluster" "private" {
  provider   = google-beta
  name       = "private"
  location   = var.region
  network    = var.network_name
  subnetwork = var.subnetwork_id
  private_cluster_config {
    enable_private_endpoint = false
    enable_private_nodes    = true
    master_ipv4_cidr_block  = var.gke_master_ipv4_cidr_block
  }
  master_authorized_networks_config {
    dynamic "cidr_blocks" {
      for_each = var.authorized_source_ranges
      content {
        cidr_block = cidr_blocks.value
      }
    }
  }
  maintenance_policy {
    recurring_window {
      start_time = "2021-06-18T00:00:00Z"
      end_time   = "2050-01-01T04:00:00Z"
      recurrence = "FREQ=WEEKLY"
    }
  }
  enable_autopilot = true
  ip_allocation_policy {
    cluster_secondary_range_name  = "pods"
    services_secondary_range_name = "services"
  }
  release_channel {
    channel = "REGULAR"
  }
  project = var.project_id
  vertical_pod_autoscaling {
    enabled = true
  }
}