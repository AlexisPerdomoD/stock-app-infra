variable "project_name" {
  type        = string
  description = "Project name"
}

variable "subnet_id" {
  type        = string
  description = "Subnet where EC2 will be launched"
}

variable "security_group_id" {
  type        = string
  description = "Security group for EC2"
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "backend_port" {
  type    = number
  default = 8080
}

variable "env_vars" {
  type        = map(string)
  description = "Environment variables for backend"
}

variable "ami_id" {
  type        = string
  description = "AMI ID (Ubuntu-based)"
  default     = "ami-localstack"
}

variable "artifact_key" {
  type        = string
  description = "Key for artifact"
  default     = "backend/latest"
}

variable "artifact_bucket" {
  type        = string
  description = "Bucket for artifact"
  default     = "stock-artifacts"
}
