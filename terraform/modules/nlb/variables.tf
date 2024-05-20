variable "TAG" {
  type    = string
  default = "k8s-loadbalancer"
}

variable "VPC_ID" {
  type = string
}

variable "SUBNET_IDS" {
  type = list(string)
}

variable "NAT_PUBLIC_IPS" {
  type = string
}
