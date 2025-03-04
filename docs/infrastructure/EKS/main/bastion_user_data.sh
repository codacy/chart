#!/bin/bash
# Bastion host setup script for EKS cluster administration
# Generated at: ${timestamp}

# Enable logging
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1
echo "Starting bastion host setup script"

# Exit on error
set -e

# Update system packages
echo "Updating system packages"
yum update -y
yum install -y unzip jq wget curl git bash-completion

# Install AWS CLI v2
echo "Installing AWS CLI v2"
curl -s "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip -q awscliv2.zip
./aws/install
rm -rf aws awscliv2.zip
aws --version

# Install kubectl from Amazon EKS
echo "Installing kubectl from Amazon EKS"

# Download kubectl binary from Amazon EKS
echo "Installing kubectl version ${KUBECTL_VERSION}"

# Use the official AWS EKS kubectl binary URL
curl -s -o kubectl "https://s3.us-west-2.amazonaws.com/amazon-eks/1.27.16/2024-12-12/bin/linux/amd64/kubectl"

# Verify download succeeded
if [ $? -ne 0 ] || [ ! -f kubectl ]; then
  echo "Failed to download kubectl from Amazon EKS, trying alternative source"
  
  # Try downloading from official Kubernetes release
  curl -LO "https://dl.k8s.io/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl"
  
  if [ $? -ne 0 ] || [ ! -f kubectl ]; then
    echo "Failed to download kubectl, trying package manager"
    amazon-linux-extras enable kubernetes
    yum install -y kubectl
  fi
fi

# Make kubectl executable and move to path if we have the binary
if [ -f kubectl ]; then
  chmod +x kubectl
  mv kubectl /usr/local/bin/
  echo "kubectl binary installed to /usr/local/bin/kubectl"
fi

# Verify kubectl installation
kubectl version --client || echo "kubectl installation verification failed, but continuing setup"

# Install kubectl bash completion
echo "Installing kubectl bash completion"
echo 'source <(kubectl completion bash)' >> /etc/bashrc
echo 'alias k=kubectl' >> /etc/bashrc
echo 'complete -o default -F __start_kubectl k' >> /etc/bashrc

# Install helm directly from binary release
echo "Installing Helm version ${HELM_VERSION}"

# Download and install Helm binary
curl -s -L https://get.helm.sh/helm-${HELM_VERSION}-linux-amd64.tar.gz -o helm.tar.gz
if [ $? -ne 0 ] || [ ! -f helm.tar.gz ]; then
  echo "Failed to download Helm tarball, trying alternative URL"
  curl -s -L https://github.com/helm/helm/releases/download/${HELM_VERSION}/helm-${HELM_VERSION}-linux-amd64.tar.gz -o helm.tar.gz
fi

# Extract and install Helm if download was successful
if [ -f helm.tar.gz ]; then
  tar -zxf helm.tar.gz
  mv linux-amd64/helm /usr/local/bin/helm
  rm -rf linux-amd64 helm.tar.gz
  echo "Helm binary installed to /usr/local/bin/helm"
else
  echo "All Helm download methods failed, but continuing setup"
fi

# Verify Helm installation
helm version || echo "Helm installation verification failed, but continuing setup"

# Install helm bash completion
echo "Installing helm bash completion"
helm completion bash > /etc/bash_completion.d/helm

# Install AWS IAM Authenticator for Kubernetes
echo "Installing AWS IAM Authenticator for Kubernetes"
curl -Lo aws-iam-authenticator https://github.com/kubernetes-sigs/aws-iam-authenticator/releases/download/v0.6.11/aws-iam-authenticator_0.6.11_linux_amd64
chmod +x ./aws-iam-authenticator
mv ./aws-iam-authenticator /usr/local/bin/aws-iam-authenticator
aws-iam-authenticator version || echo "AWS IAM Authenticator installation verification failed, but continuing setup"

# Configure kubectl for the EKS cluster
echo "Configuring kubectl for EKS cluster ${cluster_name}"
mkdir -p /root/.kube

# Get cluster endpoint and certificate data
CLUSTER_ENDPOINT=$(aws eks describe-cluster --name ${cluster_name} --region ${region} --query "cluster.endpoint" --output text)
CERTIFICATE_DATA=$(aws eks describe-cluster --name ${cluster_name} --region ${region} --query "cluster.certificateAuthority.data" --output text)

if [ -n "$CLUSTER_ENDPOINT" ] && [ -n "$CERTIFICATE_DATA" ]; then
  echo "Creating kubeconfig using cluster endpoint: $CLUSTER_ENDPOINT"
  
  # Create kubeconfig file with aws-iam-authenticator
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
  echo "Failed to get cluster endpoint and certificate data, trying aws eks update-kubeconfig"
  aws eks update-kubeconfig --name ${cluster_name} --region ${region} --kubeconfig /root/.kube/config
fi

# Make kubectl config accessible to ec2-user
mkdir -p /home/ec2-user/.kube
cp /root/.kube/config /home/ec2-user/.kube/
chown -R ec2-user:ec2-user /home/ec2-user/.kube
echo 'export KUBECONFIG=/home/ec2-user/.kube/config' >> /home/ec2-user/.bashrc
echo 'source <(kubectl completion bash)' >> /home/ec2-user/.bashrc

# Test kubectl connection
echo "Testing kubectl connection to cluster"
kubectl get nodes || echo "Warning: Unable to connect to the cluster, but continuing with setup"

# Install SSM agent
echo "Installing and starting SSM agent"
yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
systemctl enable amazon-ssm-agent
systemctl start amazon-ssm-agent

# Create a welcome message
echo "Creating welcome message"
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

echo "Bastion host setup complete"
