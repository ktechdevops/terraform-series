# Security groups

locals {
  cloudflare_ip = [
    "173.245.48.0/20",
    "103.21.244.0/22",
    "103.22.200.0/22",
    "103.31.4.0/22",
    "141.101.64.0/18",
    "108.162.192.0/18",
    "190.93.240.0/20",
    "188.114.96.0/20",
    "197.234.240.0/22",
    "198.41.128.0/17",
    "162.158.0.0/15",
    "104.16.0.0/13",
    "104.24.0.0/14",
    "172.64.0.0/13",
    "131.0.72.0/22"
  ]

  cloudflare_ipv6 = [
    "2400:cb00::/32",
    "2606:4700::/32",
    "2803:f800::/32",
    "2405:b500::/32",
    "2405:8100::/32",
    "2a06:98c0::/29",
    "2c0f:f248::/32",
  ]
}

resource "aws_security_group" "bastion-host" {
  vpc_id      = var.VPC_ID
  name        = "${var.NAME}-bastion-sg"
  description = "Security group for bastion host"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.VPC_CIDR]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.NAME}-bastion-sg"
  }
}

resource "aws_security_group" "alb-security-group" {
  vpc_id      = var.VPC_ID
  name        = "${var.NAME}-alb-sg"
  description = "Security group for ALB - Application Load Balancer"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = local.cloudflare_ip
    ipv6_cidr_blocks = local.cloudflare_ipv6
  }
  ingress {
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = local.cloudflare_ip
    ipv6_cidr_blocks = local.cloudflare_ipv6
  }

  tags = {
    Name = "${var.NAME}-alb-sg"
  }
}

resource "aws_security_group" "build-server-security-group" {
  vpc_id      = var.VPC_ID
  name        = "${var.NAME}-build-server-sg"
  description = "Security group for Jenkins cicd host"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # jenkins
  ingress {
    from_port = 8080
    to_port   = 8080
    protocol  = "tcp"
    security_groups = [
      aws_security_group.alb-security-group.id,
    ]
  }

  # sonarqube
  ingress {
    from_port = 9000
    to_port   = 9000
    protocol  = "tcp"
    security_groups = [
      aws_security_group.alb-security-group.id,
    ]
  }

  # ssh
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.VPC_CIDR]
  }

  tags = {
    Name = "${var.NAME}-build-server-sg"
  }
}
