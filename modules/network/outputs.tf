output "network-id" {
  value = google_compute_network.custom.id
}

output "network-name" {
  value = google_compute_network.custom.name
}

output "subnetwork-id" {
  value = google_compute_subnetwork.web.id
}
