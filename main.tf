terraform {
  required_version = ">= 1.6.0"
  required_providers {
    render = {
      source  = "render-oss/render"
      version = "~> 1.5"
    }

    cockroach = {
      source  = "cockroachdb/cockroach"
      version = "~> 1.9"
    }

    random = {
      source  = "hashicorp/random"
      version = "~> 3.7"
    }
  }
}

provider "cockroach" {
  apikey = var.cockroach_api_key
}



provider "render" {
  api_key  = var.render_api_key
  owner_id = var.render_owner_id
}

module "database" {
  source       = "./modules/database"
  project_name = var.project_name
}

module "backend" {
  source       = "./modules/backend"
  project_name = var.project_name
  region       = var.region
  repo_url     = "https://github.com/AlexisPerdomoD/stock-app-api"

  cr_host     = module.database.cr_host
  cr_port     = module.database.cr_port
  cr_user     = module.database.cr_user
  cr_password = module.database.cr_password
  cr_db       = module.database.cr_db
  cr_ssl      = module.database.cr_ssl

  main_source_stock_uri = var.main_source_stock_uri
  main_source_stock_key = var.main_source_stock_key

  session_secret = var.session_secret
  gin_mode       = "debug"
}

module "frontend" {
  source       = "./modules/frontend"
  repo_url     = "https://github.com/AlexisPerdomoD/stock-app-front"
  api_url      = module.backend.api_url
  project_name = var.project_name
}
