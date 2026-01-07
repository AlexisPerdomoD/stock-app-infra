



locals {
  user_data = <<-EOF
    #!/bin/bash
    set -e

    apt-get update -y
    apt-get install -y awscli

    aws s3 cp s3://${var.artifact_bucket}/${var.artifact_key} /usr/local/bin/backend
    chmod +x /usr/local/bin/backend

    cat <<EOT > /etc/backend.env
    %{for k, v in var.env_vars~}
    ${k}=${v}
    %{endfor~}
    EOT

    cat <<EOT > /etc/systemd/system/backend.service
    [Unit]
    Description=Stock Backend
    After=network.target

    [Service]
    EnvironmentFile=/etc/backend.env
    ExecStart=/usr/local/bin/backend
    Restart=always

    [Install]
    WantedBy=multi-user.target
    EOT

    systemctl daemon-reload
    systemctl enable backend
    systemctl start backend
  EOF
}

resource "aws_iam_role" "this" {
  name = "${var.project_name}-backend-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}


resource "aws_iam_policy" "s3_read_artifacts" {
  name = "${var.project_name}-backend-s3-read"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "s3:GetObject"
      ]
      Resource = "arn:aws:s3:::${var.artifact_bucket}/*"
    }]
  })
}


resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.s3_read_artifacts.arn
}


resource "aws_iam_instance_profile" "this" {
  name = "${var.project_name}-backend-profile"
  role = aws_iam_role.this.name
}

resource "aws_instance" "this" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [var.security_group_id]

  user_data            = local.user_data
  iam_instance_profile = aws_iam_instance_profile.this.name
  tags = {
    Name = "${var.project_name}-backend"
  }
}

## REFERENCE FOR BINARY BUILDING MANUALLY FOR LOCAL STACK

# export AWS_ACCESS_KEY_ID=test
# export AWS_SECRET_ACCESS_KEY=test
# export AWS_DEFAULT_REGION=us-east-1
#
# aws --endpoint-url=http://localhost:4566 s3 mb s3://stock-artifacts
# GOOS=linux GOARCH=amd64 go build -o backend ./cmd/server
# aws --endpoint-url=http://localhost:4566 s3 cp backend s3://stock-artifacts/backend
