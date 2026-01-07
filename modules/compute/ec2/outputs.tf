output "backend_public_ip" {
  value       = aws_instance.this.public_ip
  description = "IP pública de la instancia EC2 del backend"
}

output "backend_private_ip" {
  value       = aws_instance.this.private_ip
  description = "IP privada de la instancia EC2 del backend"
}

output "backend_instance_id" {
  value       = aws_instance.this.id
  description = "ID de la instancia EC2 del backend"
}

output "backend_iam_role_name" {
  value       = aws_iam_role.this.name
  description = "Nombre del IAM Role asignado al backend"
}

output "backend_iam_instance_profile" {
  value       = aws_iam_instance_profile.this.name
  description = "Nombre del instance profile asociado a la instancia"
}
