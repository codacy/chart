#!/bin/bash

# EKS worker node bootstrap script
# This script is used to bootstrap worker nodes to join the EKS cluster

set -o xtrace

# Install SSM Agent for remote access
yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
systemctl start amazon-ssm-agent
systemctl enable amazon-ssm-agent

# Bootstrap the node to join the EKS cluster
/etc/eks/bootstrap.sh ${cluster_name} ${bootstrap_extra_args}
