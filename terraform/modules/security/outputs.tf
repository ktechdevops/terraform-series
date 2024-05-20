output "bastion-sg" {
  value = aws_security_group.bastion-host.id
}

output "build-server-sg" {
  value = aws_security_group.build-server-security-group.id
}

output "alb-sg" {
  value = aws_security_group.alb-security-group.id
}
