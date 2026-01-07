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



variable "localstack_ep" {
  type = string
}

## BACKEND

variable "backend_main_data_source_uri" {
  type = string
}

variable "backend_main_data_source_key" {
  type      = string
  sensitive = true
}

variable "backend_session_secret" {
  type      = string
  sensitive = true
}

variable "backend_gin_mode" {
  type = string
}

variable "backend_instance_type" {
  type    = string
  default = "t3.micro"
}

variable "backend_ami_id" {
  type        = string
  description = "AMI ID (Ubuntu-based)"
  default     = "ami-localstack"
}

variable "backend_artifact_key" {
  type        = string
  description = "Key for artifact"
  default     = "backend/latest"
}

variable "backend_artifact_bucket" {
  type        = string
  description = "Bucket for artifact"
  default     = "stock-artifacts"
}

## FRONTEND

variable "frontend_artifact_bucket" {
  type        = string
  description = "Bucket for frontend artifact"
  default     = "stock-artifacts"
}

variable "frontend_dist_path" {
  type        = string
  description = "Local path to frontend build (dist)"
  default     = "../../frontend/dist"
}
