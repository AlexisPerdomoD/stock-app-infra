terraform {
  required_providers {
    render = {
      source  = "render-oss/render"
      version = "~> 1.5"
    }
  }
}

resource "render_static_site" "web" {
  name   = "${var.project_name}-web"
  plan   = "free"
  repo   = var.repo_url
  branch = "dev"

  build_command = "npm install && npm run build"
  publish_path  = "dist"

  env_vars = {
    VITE_APP_API_URL     = var.api_url
    VITE_APP_SESSION_KEY = "stock-app-session"
  }
}
