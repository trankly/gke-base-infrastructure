provider "google" {
  alias   = "bootstrap"
  region  = var.region
  project = var.bootstrap_project
}

provider "google" {
  region  = var.region
  project = local.project_name
}

provider "google-beta" {
  region  = var.region
  project = local.project_name
}