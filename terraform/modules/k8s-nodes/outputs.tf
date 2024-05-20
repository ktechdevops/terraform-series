output "instance_private_ip" {
  description = "Private IP address of the EC2 instance"
  value       = aws_instance.cluster-node[*].private_ip
}

output "node_sg_id" {
  description = "security group id for nodes"
  value       = aws_security_group.instance-sg.id
}
