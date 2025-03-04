output "cluster_endpoint" {
  value = aws_eks_cluster.main.endpoint
}

locals {
  aws_auth_configmap = <<-EOF


  apiVersion: v1
  kind: ConfigMap
  metadata:
    name: aws-auth
    namespace: kube-system
  data:
    mapRoles: |
      - rolearn: ${aws_iam_role.eks_worker.arn}
        username: system:node:{{EC2PrivateDNSName}}
        groups:
          - system:bootstrappers
          - system:nodes
  EOF
}

output "aws_auth_configmap" {
  # Add this to your cluster by running:
  #   terraform output aws_auth_configmap | kubectl apply -f -
  #
  value = local.aws_auth_configmap
}

output "bastion_host_id" {
  description = "ID of the bastion host"
  value       = var.create_bastion ? aws_instance.bastion[0].id : "Bastion host not created"
}

output "bastion_host_private_ip" {
  description = "Private IP address of the bastion host"
  value       = var.create_bastion ? aws_instance.bastion[0].private_ip : "Bastion host not created"
}

output "bastion_connection_command" {
  description = "Command to connect to the bastion host using AWS SSM Session Manager"
  value       = var.create_bastion ? "aws ssm start-session --target ${aws_instance.bastion[0].id}" : "Bastion host not created"
}
