#!/bin/bash
#
# Setup for Control Plane (Master) servers

set -euxo pipefail

# If you need public access to API server using the servers Public IP adress, change PUBLIC_IP_ACCESS to true.

PUBLIC_IP_ACCESS="true"
NODENAME=$(hostname -s)
POD_CIDR="192.168.0.0/16"
SVC_CIDR="20.96.0.0/12"
LOADBALANCER=k8s-loadbalancer-2f854533b4a18477.elb.us-east-2.amazonaws.com

# Pull required images

sudo kubeadm config images pull

# Initialize kubeadm based on PUBLIC_IP_ACCESS

if [[ "$PUBLIC_IP_ACCESS" == "false" ]]; then
    
    MASTER_PRIVATE_IP=$(ip addr show eth0 | awk '/inet / {print $2}' | cut -d/ -f1)
    sudo kubeadm init --apiserver-advertise-address="$MASTER_PRIVATE_IP" --apiserver-cert-extra-sans="$MASTER_PRIVATE_IP" --pod-network-cidr="$POD_CIDR" --node-name "$NODENAME" --ignore-preflight-errors Swap

elif [[ "$PUBLIC_IP_ACCESS" == "true" ]]; then

    # MASTER_PUBLIC_IP=$(curl ifconfig.me && echo "")
    MASTER_PUBLIC_IP=$LOADBALANCER
    MASTER_PRIVATE_IP=$(ip addr show ens5 | awk '/inet / {print $2}' | cut -d/ -f1)
    sudo kubeadm init --control-plane-endpoint="$MASTER_PUBLIC_IP" --apiserver-cert-extra-sans="$MASTER_PUBLIC_IP" --pod-network-cidr="$POD_CIDR" --node-name "$NODENAME" --ignore-preflight-errors Swap --service-cidr="$SVC_CIDR" --apiserver-advertise-address="$MASTER_PRIVATE_IP" --upload-certs 

else
    echo "Error: MASTER_PUBLIC_IP has an invalid value: $PUBLIC_IP_ACCESS"
    exit 1
fi

# Configure kubeconfig

mkdir -p "$HOME"/.kube
sudo cp -i /etc/kubernetes/admin.conf "$HOME"/.kube/config
sudo chown "$(id -u)":"$(id -g)" "$HOME"/.kube/config

# Install Claico Network Plugin Network 

kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml
