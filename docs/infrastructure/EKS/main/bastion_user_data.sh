#!/bin/bash

exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

set -e

yum update -y
yum install -y unzip jq wget curl git bash-completion

curl -s "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip -q awscliv2.zip
./aws/install
rm -rf aws awscliv2.zip

curl -s -o kubectl "https://s3.us-west-2.amazonaws.com/amazon-eks/${kubectl_version}/2024-12-12/bin/linux/amd64/kubectl"
if [ $? -ne 0 ] || [ ! -f kubectl ]; then
  curl -LO "https://dl.k8s.io/release/v${kubectl_version}/bin/linux/amd64/kubectl"
fi

if [ -f kubectl ]; then
  chmod +x kubectl
  mv kubectl /usr/local/bin/
fi

echo 'source <(kubectl completion bash)' >> /etc/bashrc
echo 'alias k=kubectl' >> /etc/bashrc
echo 'complete -o default -F __start_kubectl k' >> /etc/bashrc

curl -s -L https://get.helm.sh/helm-${helm_version}-linux-amd64.tar.gz -o helm.tar.gz
if [ -f helm.tar.gz ]; then
  tar -zxf helm.tar.gz
  mv linux-amd64/helm /usr/local/bin/helm
  rm -rf linux-amd64 helm.tar.gz
fi

helm completion bash > /etc/bash_completion.d/helm

curl -Lo aws-iam-authenticator https://github.com/kubernetes-sigs/aws-iam-authenticator/releases/download/v0.6.11/aws-iam-authenticator_0.6.11_linux_amd64
chmod +x ./aws-iam-authenticator
mv ./aws-iam-authenticator /usr/local/bin/aws-iam-authenticator

mkdir -p /root/.kube

CLUSTER_ENDPOINT=$(aws eks describe-cluster --name ${cluster_name} --region ${region} --query "cluster.endpoint" --output text)
CERTIFICATE_DATA=$(aws eks describe-cluster --name ${cluster_name} --region ${region} --query "cluster.certificateAuthority.data" --output text)

if [ -n "$CLUSTER_ENDPOINT" ] && [ -n "$CERTIFICATE_DATA" ]; then
  cat > /root/.kube/config << KUBECONFIG_EOF
apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: $CERTIFICATE_DATA
    server: $CLUSTER_ENDPOINT
  name: ${cluster_name}
contexts:
- context:
    cluster: ${cluster_name}
    user: aws
  name: ${cluster_name}
current-context: ${cluster_name}
kind: Config
preferences: {}
users:
- name: aws
  user:
    exec:
      apiVersion: client.authentication.k8s.io/v1beta1
      command: aws-iam-authenticator
      args:
        - token
        - -i
        - ${cluster_name}
        - --region
        - ${region}
KUBECONFIG_EOF
else
  aws eks update-kubeconfig --name ${cluster_name} --region ${region} --kubeconfig /root/.kube/config
fi

mkdir -p /home/ec2-user/.kube
cp /root/.kube/config /home/ec2-user/.kube/
chown -R ec2-user:ec2-user /home/ec2-user/.kube
echo 'export KUBECONFIG=/home/ec2-user/.kube/config' >> /home/ec2-user/.bashrc
echo 'source <(kubectl completion bash)' >> /home/ec2-user/.bashrc

yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
systemctl enable amazon-ssm-agent
systemctl start amazon-ssm-agent

cat > /etc/motd << MOTD_EOF
Welcome to the ${project_name} bastion host!

This host has kubectl and Helm installed for managing the EKS cluster.
Kubectl is already configured to connect to the ${cluster_name} cluster.

Available commands:
- kubectl: Manage the Kubernetes cluster (alias: k)
- helm: Package manager for Kubernetes
- aws: AWS CLI for interacting with AWS services

For troubleshooting, check the setup logs at /var/log/user-data.log
MOTD_EOF
