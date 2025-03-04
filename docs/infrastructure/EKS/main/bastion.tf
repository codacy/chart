# bastion.tf - Creates a bastion host in a private subnet for cluster administration

# Security group for the bastion host
resource "aws_security_group" "bastion" {
  name        = "${var.project_slug}-bastion-sg"
  description = "Security group for the bastion host"
  vpc_id      = var.create_network_stack ? aws_vpc.main[0].id : var.vpc_id

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    tomap({
      "Name" = "${var.project_slug}-bastion-sg"
    }),
    var.custom_tags
  )
}

# IAM role for the bastion host
resource "aws_iam_role" "bastion" {
  name = "${var.project_slug}-bastion-role"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = var.custom_tags
}

# Attach the SSM policy to the bastion role
resource "aws_iam_role_policy_attachment" "bastion_ssm" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  role       = aws_iam_role.bastion.name
}

# Create a custom policy for EKS access
resource "aws_iam_policy" "eks_access" {
  name        = "${var.project_slug}-eks-access"
  description = "Policy that grants access to EKS clusters for administration"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = [
          "eks:DescribeCluster",
          "eks:ListClusters",
          "eks:DescribeNodegroup",
          "eks:ListNodegroups",
          "eks:ListFargateProfiles",
          "eks:ListAddons",
          "eks:ListIdentityProviderConfigs",
          "eks:ListUpdates",
          "eks:AccessKubernetesApi"
        ]
        Resource = "*"
      },
      {
        Effect   = "Allow"
        Action   = [
          "sts:GetCallerIdentity",
          "sts:AssumeRole",
          "eks:GetToken"
        ]
        Resource = "*"
      }
    ]
  })

  tags = var.custom_tags
}

# Create a cluster role binding for the bastion host
resource "kubernetes_cluster_role_binding" "bastion_admin" {
  metadata {
    name = "bastion-admin-binding"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }
  subject {
    kind      = "User"
    name      = "system:node:${var.project_slug}-bastion"
    api_group = "rbac.authorization.k8s.io"
  }
  subject {
    kind      = "Group"
    name      = "system:masters"
    api_group = "rbac.authorization.k8s.io"
  }
  depends_on = [aws_eks_cluster.main]
}

# Attach the custom EKS access policy to the bastion role
resource "aws_iam_role_policy_attachment" "bastion_eks_access" {
  policy_arn = aws_iam_policy.eks_access.arn
  role       = aws_iam_role.bastion.name
}

# Attach the EC2 read-only policy to the bastion role
resource "aws_iam_role_policy_attachment" "bastion_ec2_read" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess"
  role       = aws_iam_role.bastion.name
}

# Instance profile for the bastion host
resource "aws_iam_instance_profile" "bastion" {
  name = "${var.project_slug}-bastion-profile-${formatdate("YYYYMMDDhhmmss", timestamp())}"
  role = aws_iam_role.bastion.name
  
  lifecycle {
    create_before_destroy = true
    ignore_changes = [name]
  }
}

# Get the latest Amazon Linux 2 AMI
data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Bastion host EC2 instance
resource "aws_instance" "bastion" {
  count = var.create_bastion ? 1 : 0

  ami                    = data.aws_ami.amazon_linux_2.id
  instance_type          = var.bastion_instance_type
  subnet_id              = var.create_network_stack ? aws_subnet.private1[0].id : var.subnet_ids[0]
  vpc_security_group_ids = [aws_security_group.bastion.id]
  iam_instance_profile   = aws_iam_instance_profile.bastion.name
  
  # Add a timestamp to force replacement when user data changes
  user_data = templatefile("${path.module}/bastion_user_data.sh", {
    cluster_name  = "${var.project_slug}-cluster"
    region        = var.aws_region
    project_name  = var.project_name
    HELM_VERSION  = var.helm_version
    KUBECTL_VERSION = var.k8s_version
    timestamp     = timestamp()
  })

  root_block_device {
    volume_type           = "gp3"
    volume_size           = var.bastion_disk_size
    delete_on_termination = true
  }

  tags = merge(
    tomap({
      "Name" = "${var.project_slug}-bastion"
    }),
    var.custom_tags
  )

  depends_on = [aws_eks_cluster.main, null_resource.bastion_user_data_hash]
  
  # Force replacement of the instance when user data changes
  lifecycle {
    create_before_destroy = true
  }
}

# Create a null resource that changes when the user data script changes
resource "null_resource" "bastion_user_data_hash" {
  count = var.create_bastion ? 1 : 0
  
  # This will change whenever the file content changes
  triggers = {
    user_data_hash = filesha256("${path.module}/bastion_user_data.sh")
  }
}

# Output the bastion host ID
output "bastion_instance_id" {
  description = "ID of the bastion host"
  value       = var.create_bastion ? aws_instance.bastion[0].id : null
}

# Output the bastion user data hash
output "bastion_user_data_hash" {
  description = "Hash of the bastion user data script (changes when the script changes)"
  value       = var.create_bastion ? null_resource.bastion_user_data_hash[0].triggers.user_data_hash : null
}
