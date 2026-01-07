output "alb_sg_id" {
  description = "Security Group ID for ALB"
  value       = aws_security_group.alb.id
}

output "backend_sg_id" {
  description = "Security Group ID for backend EC2"
  value       = aws_security_group.backend.id
}
