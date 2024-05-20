resource "aws_security_group" "instance-sg" {
  vpc_id      = var.vpc_id
  name        = "${var.tag} k8s ${var.k8s_cluster_type} SG"
  description = var.k8s_cluster_type == "control-plane" ? "k8s control-plane SG" : "k8s worker SG"

  dynamic "ingress" {
    for_each = toset(range(length(var.inbound_from_port)))
    content {
      from_port   = var.inbound_from_port[ingress.key]
      to_port     = var.inbound_to_port[ingress.key]
      protocol    = var.inbound_protocol[ingress.key]
      cidr_blocks = [var.inbound_cidr[ingress.key]]
    }
  }

  dynamic "egress" {
    for_each = toset(range(length(var.outbound_from_port)))
    content {
      from_port   = var.outbound_from_port[egress.key]
      to_port     = var.outbound_to_port[egress.key]
      protocol    = var.outbound_protocol[egress.key]
      cidr_blocks = [var.outbound_cidr[egress.key]]
    }
  }

  tags = {
    Name = "${var.tag}-${var.k8s_cluster_type}-sg"
  }
}


resource "aws_instance" "cluster-node" {
  count                  = var.instance_count
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.instance-sg.id]

  user_data = <<-EOF
    #cloud-config
    hostname: ${var.k8s_cluster_type == "control-plane" ? "mas-0${count.index + 1}" : "wrk-0${count.index + 1}"}
  EOF

  tags = {
    # Name = "k8s control-plane 0${count.index + 1}"
    Name = var.k8s_cluster_type == "control-plane" ? "k8s control-plane 0${count.index + 1}" : "k8s worker 0${count.index + 1}"
  }

  subnet_id = element(var.subnet_ids, count.index % length(var.subnet_ids))

  # root disk
  root_block_device {
    volume_size           = var.root_volume_size
    volume_type           = "gp2"
    encrypted             = true
    delete_on_termination = true
  }

  # data disk
  # ebs_block_device {
  #   device_name           = "/dev/xvda"
  #   volume_size           = "50"
  #   volume_type           = "gp2"
  #   encrypted             = true
  #   delete_on_termination = true
  # }
}
