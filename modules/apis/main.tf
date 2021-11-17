resource "google_project_service" "compute_engine" {
  service = "compute.googleapis.com"
  project = var.project_id
}

resource "google_project_service" "container" {
  service = "container.googleapis.com"
  project = var.project_id
}

resource "google_project_service" "servicenetworking" {
  service = "servicenetworking.googleapis.com"
  project = var.project_id
}

resource "google_project_service" "secretmanager" {
  service = "secretmanager.googleapis.com"
  project = var.project_id
}

resource "google_project_service" "redis" {
  service = "redis.googleapis.com"
  project = var.project_id
}

resource "google_project_service" "artifactregistry" {
  service = "artifactregistry.googleapis.com"
  project = var.project_id
}

resource "google_project_service" "cloudbuild" {
  service = "cloudbuild.googleapis.com"
  project = var.project_id
}

resource "google_project_service" "clouddeploy" {
  service = "clouddeploy.googleapis.com"
  project = var.project_id
}