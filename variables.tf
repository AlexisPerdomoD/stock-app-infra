variable "render_api_key" {
  type      = string
  sensitive = true
}

variable "render_owner_id" {
  type      = string
  sensitive = true
}

variable "cockroach_api_key" {
  type      = string
  sensitive = true
}

variable "project_name" {
  type = string
}

variable "region" {
  type    = string
  default = "oregon"
}

variable "main_source_stock_uri" {
  type = string
}

variable "main_source_stock_key" {
  type      = string
  sensitive = true
}

variable "session_secret" {
  type      = string
  sensitive = true
}

variable "gin_mode" {
  type = string
}
