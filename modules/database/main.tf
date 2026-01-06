terraform {
  required_providers {
    cockroach = {
      source = "cockroachdb/cockroach"
    }

    random = {
      source = "hashicorp/random"
    }
  }
}

resource "cockroach_cluster" "this" {
  name           = "${var.project_name}-db"
  cloud_provider = "AWS"

  regions = [{
    name = "us-east-1"
  }]

  serverless = {
    usage_limits = {
      request_unit_limit = 4000000
      storage_mib_limit  = 10000
    }
  }
}

resource "cockroach_database" "app" {
  name       = "app"
  cluster_id = cockroach_cluster.this.id
}

resource "cockroach_sql_user" "app" {
  name       = "app_user"
  cluster_id = cockroach_cluster.this.id
  password   = random_password.db.result
}

resource "random_password" "db" {
  length  = 24
  special = true
}
