
aws --profile configure sso
aws --profile sts get-caller-identity

=======================================================================
===    TERRAFORM OUTPUT
=======================================================================
bastion_ip = "18.116.8.209"
control-plane_nodes_private_ips = [
  "10.0.6.249",
  "10.0.21.53",
  "10.0.44.222",
]
loadbalancer_dns_name = "k8s-loadbalancer-2f854533b4a18477.elb.us-east-2.amazonaws.com"
nat_public_ips = tolist([
  "3.22.128.246",
])
vpc_cidr_block = "10.0.0.0/16"
vpc_enable_dns_hostnames = true
vpc_enable_dns_support = true
vpc_id = "vpc-04368b4e2d269dcc1"
worker_nodes_private_ips = []

=======================================================================
===    K8S CLUSTER
=======================================================================

You can now join any number of the control-plane node running the following command on each as root:

  kubeadm join k8s-loadbalancer-2f854533b4a18477.elb.us-east-2.amazonaws.com:6443 --token sa2yue.1vfq1dd8pvmahyih \
        --discovery-token-ca-cert-hash sha256:3cab766faf3c44750cd7fd08bb3547c5a76e6dd040fc2537a8f1aee81f8eec1b \
        --control-plane --certificate-key a75aa30769d8e7899a9c250e2d269545df4355c451407676555b7339da0ecb31

Then you can join any number of worker nodes by running the following on each as root:

kubeadm join k8s-loadbalancer-2f854533b4a18477.elb.us-east-2.amazonaws.com:6443 --token sa2yue.1vfq1dd8pvmahyih \
        --discovery-token-ca-cert-hash sha256:3cab766faf3c44750cd7fd08bb3547c5a76e6dd040fc2537a8f1aee81f8eec1b 


======================================
k taint node mas-01 node-role.kubernetes.io/control-plane:NoSchedule-