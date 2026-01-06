resource "render_web_service" "api" {
  runtime = "go"
  name    = "${var.project_name}-api"
  region  = var.region
  plan    = "free"
  repo    = var.repo_url
  branch  = "dev"

  build_command = <<EOF
curl -L https://github.com/golang-migrate/migrate/releases/download/v4.17.0/migrate.linux-amd64.tar.gz \
  | tar xvz && mv migrate /usr/local/bin/migrate

make migrate-up
go build -o app
EOF

  start_command = "./app"

  env_vars = {
    # COCKROACH
    CR_HOST        = var.cr_host
    CR_PORT        = var.cr_port
    CR_USER        = var.cr_user
    CR_PASSWORD    = var.cr_password
    CR_DB          = var.cr_db
    CR_SSL         = var.cr_ssl
    CR_RUN_MIGRATE = "TRUE"

    # DATA SOURCING
    MAIN_SOURCE_STOCK_URI = var.main_source_stock_uri
    MAIN_SOURCE_STOCK_KEY = var.main_source_stock_key

    # AUTH
    SESSION_SECRET = var.session_secret

    # SERVER
    SERVER_PORT = "3000"
    GIN_MODE    = var.gin_mode
  }
}
