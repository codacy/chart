output "cluster_endpoint" {
  description = "EKS cluster endpoint"
  value       = aws_eks_cluster.main.endpoint
}

output "cluster_name" {
  description = "EKS cluster name"
  value       = aws_eks_cluster.main.name
}

output "cluster_arn" {
  description = "EKS cluster ARN"
  value       = aws_eks_cluster.main.arn
}

output "cluster_version" {
  description = "EKS cluster version"
  value       = aws_eks_cluster.main.version
}

output "cluster_security_group_id" {
  description = "EKS cluster security group ID"
  value       = aws_security_group.eks_master.id
}

output "node_group_arn" {
  description = "EKS managed node group ARN"
  value       = aws_eks_node_group.workers.arn
}

output "node_group_status" {
  description = "EKS managed node group status"
  value       = aws_eks_node_group.workers.status
}

output "cluster_certificate_authority_data" {
  description = "Base64 encoded certificate data required to communicate with the cluster"
  value       = aws_eks_cluster.main.certificate_authority[0].data
}

output "cluster_oidc_issuer_url" {
  description = "The URL on the EKS cluster OIDC issuer"
  value       = aws_eks_cluster.main.identity[0].oidc[0].issuer
}

output "vpc_id" {
  description = "VPC ID where the cluster is deployed"
  value       = var.create_network_stack ? aws_vpc.main[0].id : var.vpc_id
}
