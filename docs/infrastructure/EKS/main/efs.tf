# efs.tf - Creates an Amazon EFS file system

# Security group for the EFS mount targets
resource "aws_security_group" "efs" {
  count       = var.create_efs ? 1 : 0
  name        = "${var.project_slug}-efs-sg"
  description = "Security group for EFS mount targets"
  vpc_id      = var.create_network_stack ? aws_vpc.main[0].id : var.vpc_id

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow NFS traffic from the worker nodes, bastion, and PostgreSQL instance
  ingress {
    from_port       = 2049
    to_port         = 2049
    protocol        = "tcp"
    security_groups = [aws_security_group.eks_worker.id]
    description     = "Allow NFS traffic from worker nodes"
  }

  ingress {
    from_port       = 2049
    to_port         = 2049
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion.id]
    description     = "Allow NFS traffic from bastion host"
  }

  dynamic "ingress" {
    for_each = var.create_postgres ? [1] : []
    content {
      from_port       = 2049
      to_port         = 2049
      protocol        = "tcp"
      security_groups = [aws_security_group.postgres[0].id]
      description     = "Allow NFS traffic from PostgreSQL instance"
    }
  }

  tags = merge(
    tomap({
      "Name" = "${var.project_slug}-efs-sg"
    }),
    var.custom_tags
  )
}

# EFS file system
resource "aws_efs_file_system" "main" {
  count = var.create_efs ? 1 : 0

  performance_mode                = var.efs_performance_mode
  throughput_mode                 = var.efs_throughput_mode
  provisioned_throughput_in_mibps = var.efs_throughput_mode == "provisioned" ? var.efs_provisioned_throughput : null

  lifecycle_policy {
    transition_to_ia = "AFTER_30_DAYS"
  }

  tags = merge(
    tomap({
      "Name" = "${var.project_slug}-efs"
    }),
    var.custom_tags
  )
}

# EFS mount targets in each private subnet
resource "aws_efs_mount_target" "private1" {
  count = var.create_efs && var.create_network_stack ? 1 : 0

  file_system_id  = aws_efs_file_system.main[0].id
  subnet_id       = aws_subnet.private1[0].id
  security_groups = [aws_security_group.efs[0].id]
}

resource "aws_efs_mount_target" "private2" {
  count = var.create_efs && var.create_network_stack ? 1 : 0

  file_system_id  = aws_efs_file_system.main[0].id
  subnet_id       = aws_subnet.private2[0].id
  security_groups = [aws_security_group.efs[0].id]
}

# EFS mount targets in provided subnets (if not creating network stack)
resource "aws_efs_mount_target" "provided" {
  count = var.create_efs && !var.create_network_stack ? length(var.subnet_ids) : 0

  file_system_id  = aws_efs_file_system.main[0].id
  subnet_id       = var.subnet_ids[count.index]
  security_groups = [aws_security_group.efs[0].id]
}

# Output the EFS file system ID
output "efs_file_system_id" {
  description = "ID of the EFS file system"
  value       = var.create_efs ? aws_efs_file_system.main[0].id : null
}

# Output the EFS DNS name
output "efs_dns_name" {
  description = "DNS name of the EFS file system"
  value       = var.create_efs ? aws_efs_file_system.main[0].dns_name : null
}

# Output the EFS mount command
output "efs_mount_command" {
  description = "Command to mount the EFS file system"
  value       = var.create_efs ? "sudo mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport ${aws_efs_file_system.main[0].dns_name}:/ /mnt/efs" : null
}
