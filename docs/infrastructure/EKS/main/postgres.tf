# postgres.tf - Creates a PostgreSQL instance in a private subnet

# Security group for the PostgreSQL instance
resource "aws_security_group" "postgres" {
  count       = var.create_postgres ? 1 : 0
  name        = "${var.project_slug}-postgres-sg"
  description = "Security group for the PostgreSQL instance"
  vpc_id      = var.create_network_stack ? aws_vpc.main[0].id : var.vpc_id

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow PostgreSQL traffic from the worker nodes and bastion
  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.eks_worker.id]
    description     = "Allow PostgreSQL traffic from worker nodes"
  }

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion.id]
    description     = "Allow PostgreSQL traffic from bastion host"
  }

  tags = merge(
    tomap({
      "Name" = "${var.project_slug}-postgres-sg"
    }),
    var.custom_tags
  )
}

# IAM role for the PostgreSQL instance
resource "aws_iam_role" "postgres" {
  count = var.create_postgres ? 1 : 0
  name  = "${var.project_slug}-postgres-role"
  
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

# Attach the SSM policy to the PostgreSQL role
resource "aws_iam_role_policy_attachment" "postgres_ssm" {
  count      = var.create_postgres ? 1 : 0
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  role       = aws_iam_role.postgres[0].name
}

# Instance profile for the PostgreSQL instance
resource "aws_iam_instance_profile" "postgres" {
  count = var.create_postgres ? 1 : 0
  name  = "${var.project_slug}-postgres-profile-${formatdate("YYYYMMDDhhmmss", timestamp())}"
  role  = aws_iam_role.postgres[0].name
  
  lifecycle {
    create_before_destroy = true
    ignore_changes = [name]
  }
}

# Get the latest Amazon Linux 2 AMI
data "aws_ami" "amazon_linux_2_postgres" {
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

# PostgreSQL instance
resource "aws_instance" "postgres" {
  count = var.create_postgres ? 1 : 0

  ami                    = data.aws_ami.amazon_linux_2_postgres.id
  instance_type          = var.postgres_instance_type
  subnet_id              = var.create_network_stack ? aws_subnet.private1[0].id : var.subnet_ids[0]
  vpc_security_group_ids = [aws_security_group.postgres[0].id]
  iam_instance_profile   = aws_iam_instance_profile.postgres[0].name
  
  user_data = templatefile("${path.module}/postgres_user_data.sh", {
    postgres_version = var.postgres_version
    postgres_password = var.postgres_password
    timestamp = timestamp()
  })

  root_block_device {
    volume_type           = "gp3"
    volume_size           = var.postgres_disk_size
    delete_on_termination = true
  }

  tags = merge(
    tomap({
      "Name" = "${var.project_slug}-postgres"
    }),
    var.custom_tags
  )

  # Force replacement of the instance when user data changes
  lifecycle {
    create_before_destroy = true
  }

  depends_on = [aws_eks_cluster.main]
}

# Create a null resource that changes when the user data script changes
resource "null_resource" "postgres_user_data_hash" {
  count = var.create_postgres ? 1 : 0
  
  # This will change whenever the file content changes
  triggers = {
    user_data_hash = filesha256("${path.module}/postgres_user_data.sh")
  }
}

# Output the PostgreSQL instance ID
output "postgres_instance_id" {
  description = "ID of the PostgreSQL instance"
  value       = var.create_postgres ? aws_instance.postgres[0].id : null
}

# Output the PostgreSQL private IP
output "postgres_private_ip" {
  description = "Private IP of the PostgreSQL instance"
  value       = var.create_postgres ? aws_instance.postgres[0].private_ip : null
}

# Output the PostgreSQL connection string
output "postgres_connection_string" {
  description = "PostgreSQL connection string"
  value       = var.create_postgres ? "postgresql://codacy:${var.postgres_password}@${aws_instance.postgres[0].private_ip}:5432/postgres" : null
  sensitive   = true
}
