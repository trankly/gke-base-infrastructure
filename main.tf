resource "random_integer" "suffix" {
  max = 999999999999
  min = 100000000000
}

locals {
  project_name = var.environment
  project_id   = "${local.project_name}-${random_integer.suffix.result}"
}

resource "google_folder" "environment" {
  display_name = var.environment
  parent       = var.parent_folder
}

module "project" {
  source          = "./modules/project/"
  folder_id       = google_folder.environment.id
  project_id      = local.project_id
  project_name    = local.project_name
  billing_account = var.billing_account
  providers = {
    google = google.bootstrap
  }
}

module "apis" {
  source     = "./modules/apis/"
  project_id = local.project_id
  providers = {
    google = google
  }
  depends_on = [module.project]
}

module "network" {
  source                   = "./modules/network/"
  authorized_source_ranges = []
  region                   = var.region
  project_id               = module.project.project_id
  depends_on = [
  module.project, module.apis]
  providers = {
    google = google
  }
}

module "compute" {
  source                   = "./modules/compute/"
  authorized_source_ranges = []
  network_name             = module.network.network-name
  project_id               = module.project.project_id
  region                   = var.region
  subnetwork_id            = module.network.subnetwork-id
  depends_on = [
  module.project, module.apis, module.network]
  providers = {
    google = google
  }
}

module "database" {
  source            = "./modules/database/"
  availability_type = var.database_availability_type
  database_version  = var.database_version
  disk_size         = var.database_disk_size
  machine_type      = var.database_machine_type
  network_id        = module.network.network-id
  project_id        = module.project.project_id
  region            = var.region
  suffix            = random_integer.suffix.result
  environment       = var.environment
  depends_on = [
  module.project, module.apis, module.network]
  providers = {
    google = google
  }
}

module "cache" {
  source      = "./modules/cache/"
  network_id  = module.network.network-id
  project_id  = module.project.project_id
  redis_size  = var.redis_size
  suffix      = random_integer.suffix.result
  environment = var.environment
  depends_on = [
  module.project, module.apis, module.network]
  providers = {
    google = google
  }
}