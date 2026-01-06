terraform {
  required_providers {
    render = {
      source = "render-oss/render"
    }
  }
}



resource "render_web_service" "api" {
  name          = "${var.project_name}-api"
  region        = var.region
  plan          = "starter"
  start_command = "./app"

  runtime_source = {
    native_runtime = {
      auto_deploy   = true
      branch        = "dev"
      build_command = <<EOF
curl -L https://github.com/golang-migrate/migrate/releases/download/v4.17.0/migrate.linux-amd64.tar.gz \
  | tar xvz && mv migrate /usr/local/bin/migrate

go build -o app
EOF
      repo_url      = var.repo_url
      runtime       = "go"
    }

  }

  env_vars = {
    # COCKROACH
    "CR_HOST"     = { value = var.cr_host }
    "CR_PORT"     = { value = var.cr_port }
    "CR_USER"     = { value = var.cr_user }
    "CR_PASSWORD" = { value = var.cr_password }
    "CR_DB"       = { value = var.cr_db }
    "CR_SSL"      = { value = var.cr_ssl }
    # DATA SOURCING
    "MAIN_SOURCE_STOCK_URI" = { value = var.main_source_stock_uri }
    "MAIN_SOURCE_STOCK_KEY" = { value = var.main_source_stock_key }
    # AUTH
    "SESSION_SECRET" = { generate_value = true }
    # SERVER
    "SERVER_PORT" = { value = "3000" }
    "GIN_MODE"    = { value = var.gin_mode }


  }

}
