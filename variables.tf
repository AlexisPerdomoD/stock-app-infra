variable "render_api_key" {
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
