output "lb_dns_name" {
  description = "Loadbalancer DNS name"
  value = aws_lb.awsnlb.dns_name
}
