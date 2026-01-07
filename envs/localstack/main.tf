terraform {
  required_version = ">= 1.6.0"
  required_providers {
    cockroach = {
      source  = "cockroachdb/cockroach"
      version = "~> 1.9"
    }

    random = {
      source  = "hashicorp/random"
      version = "~> 3.7"
    }

    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}


provider "aws" {
  region                      = "us-east-1"
  access_key                  = "test"
  secret_key                  = "test"
  skip_credentials_validation = true
  skip_requesting_account_id  = true

  endpoints {
    ec2   = var.localstack_ep
    elbv2 = var.localstack_ep
    iam   = var.localstack_ep
    sts   = var.localstack_ep
  }
}

module "network" {
  source       = "../../modules/network"
  project_name = var.project_name

}

module "security" {
  source       = "../../modules/segurity"
  vpc_id       = module.network.vpc_id
  project_name = var.project_name
}

provider "cockroach" {
  apikey = var.cockroach_api_key
}

module "database" {
  source       = "../../modules/database/cockroachdb"
  project_name = var.project_name
}



module "backend" {
  source            = "../../modules/compute/ec2"
  project_name      = var.project_name
  subnet_id         = module.network.public_subnet_id
  security_group_id = module.security.backend_sg_id

  instance_type   = var.backend_instance_type
  ami_id          = var.backend_ami_id
  artifact_key    = var.backend_artifact_key
  artifact_bucket = var.backend_artifact_bucket

  env_vars = {
    CR_HOST     = module.database.cr_host
    CR_PORT     = module.database.cr_port
    CR_USER     = module.database.cr_user
    CR_PASSWORD = module.database.cr_password
    CR_DB       = module.database.cr_db
    CR_SSL      = module.database.cr_ssl

    MAIN_SOURCE_STOCK_URI = var.backend_main_data_source_uri
    MAIN_SOURCE_STOCK_KEY = var.backend_main_data_source_key

    GIN_MODE = var.backend_gin_mode
  }
}


module "frontend" {
  source       = "../../modules/frontend/s3_site"
  project_name = var.project_name
  bucket_name  = var.frontend_artifact_bucket
  dist_path    = var.frontend_dist_path

}

