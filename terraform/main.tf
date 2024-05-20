# main.tf

module "vpc" {
  source   = "./modules/vpc"
  vpc_cidr = "10.0.0.0/16"
}

module "security-groups" {
  source   = "./modules/security"
  NAME     = var.name
  VPC_ID   = module.vpc.vpc_id
  VPC_CIDR = module.vpc.vpc_cidr_block
}

module "key-pair" {
  source          = "./modules/keys"
  KEYPAIR_NAME    = var.keypair_name
  PUBLIC_KEY_PATH = var.pub_key_path
}

module "bastion" {
  source                      = "./modules/ec2"
  AMI_ID                      = data.aws_ami.ubuntu-22-04.id
  INSTANCE_TYPE               = "t2.nano"
  HOSTNAME                    = "bastion"
  SUBNET_ID                   = module.vpc.public_subnets[0]
  KEY_NAME                    = module.key-pair.keypair_name
  VPC_SECURITY_GROUP_IDS      = [module.security-groups.bastion-sg]
  ASSOCIATE_PUBLIC_IP_ADDRESS = true
}


module "k8s_control_plane" {
  source = "./modules/k8s-nodes"

  instance_count   = 3
  tag              = var.name
  vpc_id           = module.vpc.vpc_id
  ami_id           = data.aws_ami.ubuntu-22-04.id
  instance_type    = "t3.xlarge"
  k8s_cluster_type = "control-plane"
  root_volume_size = "50"
  key_name         = module.key-pair.keypair_name
  subnet_ids       = module.vpc.private_subnets

  inbound_from_port = ["0", "0", "80", "443", "6443", "22"]
  inbound_to_port   = ["0", "0", "80", "443", "6443", "22", ]
  inbound_protocol  = ["ALL", "ALL", "TCP", "TCP", "TCP", "TCP", ]
  inbound_cidr = [
    module.vpc.vpc_cidr_block,
    "192.168.0.0/16",
    "0.0.0.0/0",
    "0.0.0.0/0",
    "0.0.0.0/0",
    "0.0.0.0/0"
  ]
  outbound_from_port = ["0"]
  outbound_to_port   = ["0"]
  outbound_protocol  = ["-1"]
  outbound_cidr      = ["0.0.0.0/0"]
}

module "k8s_worker" {
  source = "./modules/k8s-nodes"

  instance_count   = 0
  tag              = var.name
  vpc_id           = module.vpc.vpc_id
  ami_id           = data.aws_ami.ubuntu-22-04.id
  instance_type    = "t3.large"
  k8s_cluster_type = "worker"
  root_volume_size = "50"
  key_name         = module.key-pair.keypair_name
  subnet_ids       = module.vpc.private_subnets

  inbound_from_port = ["0", "0", "443", "80", "22"]
  inbound_to_port   = ["0", "0", "443", "80", "22"]
  inbound_protocol  = ["ALL", "ALL", "TCP", "TCP", "TCP"]
  inbound_cidr = [
    module.vpc.vpc_cidr_block,
    "192.168.0.0/16",
    "0.0.0.0/0",
    "0.0.0.0/0",
    "0.0.0.0/0"
  ]
  outbound_from_port = ["0"]
  outbound_to_port   = ["0"]
  outbound_protocol  = ["-1"]
  outbound_cidr      = ["0.0.0.0/0"]
}

module "load_balancer" {
  source         = "./modules/nlb"
  TAG            = "k8s-loadbalancer"
  VPC_ID         = module.vpc.vpc_id
  SUBNET_IDS     = module.vpc.public_subnets
  NAT_PUBLIC_IPS = module.vpc.nat_public_ips[0]
}
