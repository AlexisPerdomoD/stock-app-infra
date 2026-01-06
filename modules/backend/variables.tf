variable "project_name" {
  type = string
}

variable "region" {
  type = string
}

variable "repo_url" {
  type = string
}

variable "cr_host" {
  type = string
}

variable "cr_port" {
  type = string
}

variable "cr_user" {
  type = string
}

variable "cr_password" {
  type      = string
  sensitive = true
}

variable "cr_db" {
  type = string
}

variable "cr_ssl" {
  type = string
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
