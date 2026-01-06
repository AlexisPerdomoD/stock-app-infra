terraform {
  required_providers {
    cockroachdb = {
      source  = "cockroachdb/cockroach"
      version = "~> 1.9"
    }

    random = {
      source  = "hashicorp/random"
      version = "~> 3.7"
    }
  }
}

resource "cockroachdb_cluster" "this" {
  name           = "${var.project_name}-db"
  cloud_provider = "aws"
  region         = "us-east-1"
  serverless     = true
}

resource "cockroachdb_database" "app" {
  name       = "app"
  cluster_id = cockroachdb_cluster.this.id
}

resource "cockroachdb_user" "app" {
  name       = "app_user"
  cluster_id = cockroachdb_cluster.this.id
  password   = random_password.db.result
}

resource "random_password" "db" {
  length  = 24
  special = true
}
