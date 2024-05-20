output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = module.vpc.vpc_cidr_block
}

output "vpc_enable_dns_support" {
  description = "Whether or not the VPC has DNS support"
  value       = module.vpc.vpc_enable_dns_support
}

output "vpc_enable_dns_hostnames" {
  description = "Whether or not the VPC has DNS hostname support"
  value       = module.vpc.vpc_enable_dns_hostnames
}

output "bastion_ip" {
  description = "IP address of bastion"
  value       = module.bastion.instance_public_ip
}

output "control-plane_nodes_private_ips" {
  description = "Private IP address of control-plane instances"
  value       = module.k8s_control_plane.instance_private_ip
}

output "worker_nodes_private_ips" {
  description = "Private IP address of worker instances"
  value       = module.k8s_worker.instance_private_ip
}

output "nat_public_ips" {
  value = module.vpc.nat_public_ips
}

output "loadbalancer_dns_name" {
  description = "Loadbalancer DNS name"
  value = module.load_balancer.lb_dns_name
}
