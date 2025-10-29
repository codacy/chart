resource "aws_security_group" "bastion" {
  count       = var.create_bastion ? 1 : 0
  name        = "${var.project_slug}-bastion-sg"
  description = "Security group for the bastion host"
  vpc_id      = var.create_network_stack ? aws_vpc.main[0].id : var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    {
      "Name" = "${var.project_slug}-bastion-sg"
    },
    var.custom_tags
  )
}

resource "aws_iam_role" "bastion" {
  count = var.create_bastion ? 1 : 0
  name  = "${var.project_slug}-bastion-role"

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

resource "aws_iam_role_policy_attachment" "bastion_ssm" {
  count      = var.create_bastion ? 1 : 0
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  role       = aws_iam_role.bastion[0].name
}

resource "aws_iam_policy" "eks_access" {
  count       = var.create_bastion ? 1 : 0
  name        = "${var.project_slug}-eks-access"
  description = "Policy that grants access to EKS clusters for administration"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
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
        Effect = "Allow"
        Action = [
          "sts:GetCallerIdentity",
          "eks:GetToken"
        ]
        Resource = "*"
      }
    ]
  })

  tags = var.custom_tags
}

resource "aws_iam_role_policy_attachment" "bastion_eks_access" {
  count      = var.create_bastion ? 1 : 0
  policy_arn = aws_iam_policy.eks_access[0].arn
  role       = aws_iam_role.bastion[0].name
}

resource "aws_iam_role_policy_attachment" "bastion_ec2_read" {
  count      = var.create_bastion ? 1 : 0
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess"
  role       = aws_iam_role.bastion[0].name
}

resource "aws_iam_instance_profile" "bastion" {
  count = var.create_bastion ? 1 : 0
  name  = "${var.project_slug}-bastion-profile"
  role  = aws_iam_role.bastion[0].name

  lifecycle {
    create_before_destroy = true
  }
}

data "aws_ami" "amazon_linux_2" {
  count       = var.create_bastion ? 1 : 0
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

resource "aws_instance" "bastion" {
  count = var.create_bastion ? 1 : 0

  ami                    = data.aws_ami.amazon_linux_2[0].id
  instance_type          = var.bastion_instance_type
  subnet_id              = var.create_network_stack ? aws_subnet.private1[0].id : var.subnet_ids[0]
  vpc_security_group_ids = [aws_security_group.bastion[0].id]
  iam_instance_profile   = aws_iam_instance_profile.bastion[0].name

  user_data = base64encode(templatefile("${path.module}/bastion_user_data.sh", {
    cluster_name    = "${var.project_slug}-cluster"
    region          = var.aws_region
    project_name    = var.project_name
    helm_version    = var.helm_version
    kubectl_version = var.k8s_version
  }))

  root_block_device {
    volume_type           = "gp3"
    volume_size           = var.bastion_disk_size
    delete_on_termination = true
    encrypted             = true
  }

  tags = merge(
    {
      "Name" = "${var.project_slug}-bastion"
    },
    var.custom_tags
  )

  depends_on = [aws_eks_cluster.main]

  lifecycle {
    create_before_destroy = true
  }
}
