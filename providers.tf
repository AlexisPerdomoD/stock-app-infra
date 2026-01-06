
terraform {
  required_version = ">= 1.6.0"

  required_providers {
    render = {
      source  = "render-oss/render"
      version = "~> 1.5"
    }

    cockroachdb = {
      source  = "cockroachdb/cockroach"
      version = "~> 1.9"
    }
  }
}

provider "render" {
  api_key = var.render_api_key
}

provider "cockroachdb" {
  api_key = var.cockroach_api_key
}
