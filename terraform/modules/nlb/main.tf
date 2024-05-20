# control plane security group
resource "aws_security_group" "nlb-sg" {
  vpc_id      = var.VPC_ID
  name        = "${var.TAG}-sg"
  description = "Security group for ${var.TAG}"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 6443
    to_port   = 6443
    protocol  = "tcp"
    cidr_blocks = [
      "75.119.130.251/32",
      "${var.NAT_PUBLIC_IPS}/32"
    ]
  }

  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 443
    to_port   = 443
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.TAG}-sg"
  }
}

##############################################
#     NLB SECTION
##############################################

resource "aws_lb" "awsnlb" {
  name                       = "${var.TAG}"
  internal                   = false
  load_balancer_type         = "network"
  security_groups            = [aws_security_group.nlb-sg.id]
  subnets                    = var.SUBNET_IDS
  enable_deletion_protection = true

  tags = {
    Name = "${var.TAG}"
  }
}

# control-plane
resource "aws_lb_target_group" "controlplane" {
  name     = "controlplane"
  port     = 6443
  protocol = "TCP"
  vpc_id   = var.VPC_ID
}

resource "aws_lb_listener" "lb_listener" {
  load_balancer_arn = aws_lb.awsnlb.arn
  port              = 6443
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.controlplane.arn
  }
}

# http
resource "aws_lb_target_group" "http" {
  name     = "http"
  port     = 80
  protocol = "TCP"
  vpc_id   = var.VPC_ID
}

resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.awsnlb.arn
  port              = 80
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.http.arn
  }
}

# https
resource "aws_lb_target_group" "https" {
  name     = "https"
  port     = 443
  protocol = "TCP"
  vpc_id   = var.VPC_ID
}

resource "aws_lb_listener" "https_listener" {
  load_balancer_arn = aws_lb.awsnlb.arn
  port              = 443
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.https.arn
  }
}