terraform {
  required_providers {
    render = {
      source  = "render-oss/render"
      version = "~> 1.5"
    }
  }
}

resource "render_static_site" "web" {
  name          = "${var.project_name}-web"
  branch        = "dev"
  repo_url      = var.repo_url
  build_command = "npm install && npm run build"
  publish_path  = "dist"

  env_vars = {
    "VITE_APP_API_URL"     = { value = var.api_url }
    "VITE_APP_SESSION_KEY" = { value = "stock-app-session" }
  }

}
