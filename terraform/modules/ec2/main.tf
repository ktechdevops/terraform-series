
resource "aws_instance" "ec2" {
  ami                         = var.AMI_ID
  instance_type               = var.INSTANCE_TYPE
  key_name                    = var.KEY_NAME
  associate_public_ip_address = var.ASSOCIATE_PUBLIC_IP_ADDRESS
  vpc_security_group_ids      = var.VPC_SECURITY_GROUP_IDS

  # count = var.INSTANCE_COUNT
  # vpc_security_group_ids = [aws_security_group.instance-sg.id]

  user_data = <<-EOF
    #cloud-config
    hostname: ${var.HOSTNAME}
  EOF

  tags = {
    Name = "${var.NAME_PRFIX}-${var.HOSTNAME}"
  }

  subnet_id = var.SUBNET_ID

  # root disk
  root_block_device {
    volume_size           = var.ROOT_VOLUME_SIZE
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
