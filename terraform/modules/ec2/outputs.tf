# EC2 outputs
output "ec2_id" {
  description = "The ID of the instance"
  value       = aws_instance.ec2.id
}

output "ec2_primary_network_interface_id" {
  description = "The ID of the instance's primary network interface"
  value       = aws_instance.ec2.primary_network_interface_id
}

output "ec2_private_dns" {
  description = "The private DNS name assigned to the instance. Can only be used inside the Amazon EC2, and only available if you've enabled DNS hostnames for your VPC"
  value       = aws_instance.ec2.private_dns
}

output "ec2_public_dns" {
  description = "The public DNS name assigned to the instance. For EC2-VPC, this is only available if you've enabled DNS hostnames for your VPC"
  value       = aws_instance.ec2.public_dns
}

output "instance_public_ip" {
  description = "The public IP address assigned to the instance, if applicable. NOTE: If you are using an aws_eip with your instance, you should refer to the EIP's address directly and not use `public_ip` as this field will change after the EIP is attached"
  value       = aws_instance.ec2.public_ip
}

output "instance_private_ip" {
  description = "Private IP address of the EC2 instance"
  value       = aws_instance.ec2.private_ip
}

output "ec2_root_block_device" {
  description = "Root block device information"
  value       = aws_instance.ec2.root_block_device
}

output "ec2_ebs_block_device" {
  description = "EBS block device information"
  value       = aws_instance.ec2.ebs_block_device
}

output "ec2_availability_zone" {
  description = "The availability zone of the created instance"
  value       = aws_instance.ec2.availability_zone
}
