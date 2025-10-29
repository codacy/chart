# cluster_workers.tf - this creates EKS managed node groups which replace the legacy 
#                      launch configurations and autoscaling groups approach

### EKS Managed Node Group
resource "aws_eks_node_group" "workers" {
  cluster_name    = aws_eks_cluster.main.name
  node_group_name = "${var.project_slug}-workers"
  node_role_arn   = aws_iam_role.eks_node_group.arn
  subnet_ids      = var.create_network_stack ? [aws_subnet.private1[0].id, aws_subnet.private2[0].id] : var.subnet_ids

  capacity_type  = "ON_DEMAND"
  instance_types = [var.k8s_worker_type]

  scaling_config {
    desired_size = var.k8s_worker_desired
    max_size     = var.k8s_worker_max
    min_size     = var.k8s_worker_min
  }

  disk_size = var.k8s_worker_disk_size

  # Use modern gp3 storage instead of gp2
  launch_template {
    name    = aws_launch_template.workers.name
    version = aws_launch_template.workers.latest_version
  }

  # Remote access configuration (replaces manual SSH setup)
  dynamic "remote_access" {
    for_each = var.enable_ssm ? [] : [1]
    content {
      ec2_ssh_key = var.worker_ssh_key_name
    }
  }

  # Update strategy
  update_config {
    max_unavailable = 1
  }

  tags = merge(
    var.custom_tags,
    {
      "Name" = "${var.project_slug}-worker"
      "kubernetes.io/cluster/${var.project_slug}-cluster" = "owned"
      "k8s.io/cluster-autoscaler/enabled" = "true"
      "k8s.io/cluster-autoscaler/${var.project_slug}-cluster" = "owned"
    }
  )

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.eks_worker_node_policy,
    aws_iam_role_policy_attachment.eks_cni_policy,
    aws_iam_role_policy_attachment.ecr_read_only,
  ]

  lifecycle {
    ignore_changes = [scaling_config[0].desired_size]
  }
}

### Launch template for managed node group (enables gp3 and other advanced configurations)
resource "aws_launch_template" "workers" {
  name_prefix = "${var.project_slug}-workers-"

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_type           = "gp3"
      volume_size           = var.k8s_worker_disk_size
      throughput            = 125
      iops                  = 3000
      delete_on_termination = true
      encrypted             = true
    }
  }

  vpc_security_group_ids = [aws_security_group.eks_worker.id]

  tag_specifications {
    resource_type = "instance"
    tags = merge(
      var.custom_tags,
      {
        "Name" = "${var.project_slug}-worker"
        "kubernetes.io/cluster/${var.project_slug}-cluster" = "owned"
      }
    )
  }

  user_data = base64encode(templatefile("${path.module}/userdata.sh", {
    cluster_name     = aws_eks_cluster.main.name
    bootstrap_extra_args = var.k8s_worker_bootstrap_extra_flags
  }))

  lifecycle {
    create_before_destroy = true
  }

  tags = var.custom_tags
}

### EKS Node Group IAM Role
resource "aws_iam_role" "eks_node_group" {
  name = "${var.project_slug}-node-group-role"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })

  tags = var.custom_tags
}

### Required IAM policies for EKS node groups
resource "aws_iam_role_policy_attachment" "eks_worker_node_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_node_group.name
}

resource "aws_iam_role_policy_attachment" "eks_cni_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_node_group.name
}

resource "aws_iam_role_policy_attachment" "ecr_read_only" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_node_group.name
}

### Optional SSM policy for remote access
resource "aws_iam_role_policy_attachment" "ssm" {
  count      = var.enable_ssm ? 1 : 0
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  role       = aws_iam_role.eks_node_group.name
}

### EBS CSI Driver policy for persistent volumes
resource "aws_iam_role_policy_attachment" "ebs_csi_policy" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/Amazon_EBS_CSI_DriverPolicy"
  role       = aws_iam_role.eks_node_group.name
}

### Security group for worker nodes (simplified for managed node groups)
resource "aws_security_group" "eks_worker" {
  name        = "${var.project_slug}-cluster-worker"
  description = "${var.project_name} worker SG"
  vpc_id      = var.create_network_stack ? aws_vpc.main[0].id : var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    {
      "Name" = "${var.project_slug}-worker-sg"
      "kubernetes.io/cluster/${var.project_slug}-cluster" = "owned"
    },
    var.custom_tags
  )
}

# Allow communication between worker nodes
resource "aws_security_group_rule" "worker_node_ingress_self" {
  description              = "Allow nodes to communicate with each other"
  from_port                = 0
  protocol                 = "-1"
  security_group_id        = aws_security_group.eks_worker.id
  source_security_group_id = aws_security_group.eks_worker.id
  to_port                  = 65535
  type                     = "ingress"
}

# Allow worker nodes to receive communication from the cluster control plane
resource "aws_security_group_rule" "worker_node_ingress_cluster" {
  description              = "Allow worker Kubelets and pods to receive communication from the cluster control plane"
  from_port                = 1025
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks_worker.id
  source_security_group_id = aws_security_group.eks_master.id
  to_port                  = 65535
  type                     = "ingress"
}

# Allow cluster control plane to receive communication from worker nodes
resource "aws_security_group_rule" "cluster_ingress_worker_https" {
  description              = "Allow pods to communicate with the cluster API Server"
  from_port                = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks_master.id
  source_security_group_id = aws_security_group.eks_worker.id
  to_port                  = 443
  type                     = "ingress"
}
