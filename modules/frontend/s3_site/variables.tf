variable "project_name" {
  type        = string
  description = "Project name"
}

variable "bucket_name" {
  type        = string
  description = "Bucket name  for static site"
}

variable "dist_path" {
  type        = string
  description = "Local path to frontend build (dist)"
}
