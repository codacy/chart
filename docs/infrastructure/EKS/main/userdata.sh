#!/bin/bash

set -o xtrace

yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
systemctl start amazon-ssm-agent
systemctl enable amazon-ssm-agent

/etc/eks/bootstrap.sh ${cluster_name} ${bootstrap_extra_args}
