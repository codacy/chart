# network.tf - this creates the base network infrastructure required for the EKS cluster.
#              Four subnets (two private and two public) are included in the main VPC,
#              split over two availability zones. A NAT gateway is placed in each public
#              subnet to allow egress internet access for instances located on private
#              subnets. This traffic is sent via the also provided internet gateway.


resource "aws_vpc" "main" {
  count = var.create_network_stack ? 1 : 0

  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(
    tomap({
      "Name" = "${var.project_name} VPC",
      "kubernetes.io/cluster/${var.project_slug}-cluster" = "shared"
    }),
    var.custom_tags
  )
}

### public route table
resource "aws_internet_gateway" "main" {
  count = var.create_network_stack ? 1 : 0

  vpc_id = aws_vpc.main[0].id

  tags = merge(
    tomap({"Name" = var.project_name}),
    var.custom_tags
  )
}
resource "aws_route_table" "public" {
  count = var.create_network_stack ? 1 : 0

  vpc_id = aws_vpc.main[0].id

  tags = merge(
    tomap({"Name" = "${var.project_name} public route table"}),
    var.custom_tags
  )
}
resource "aws_route" "public" {
  count = var.create_network_stack ? 1 : 0

  route_table_id         = aws_route_table.public[0].id
  gateway_id             = aws_internet_gateway.main[0].id
  destination_cidr_block = "0.0.0.0/0"
}

### public subnet 1
resource "aws_subnet" "public1" {
  count = var.create_network_stack ? 1 : 0

  vpc_id            = aws_vpc.main[0].id
  cidr_block        = var.public_subnet1_cidr
  availability_zone = data.aws_availability_zones.AZs.names[0]

  map_public_ip_on_launch = true

  tags = merge(
    tomap({
      "Name" = "${var.project_name} public subnet 1",
      "kubernetes.io/cluster/${var.project_slug}-cluster" = "shared",
      "kubernetes.io/role/elb" = "1"
    }),
    var.custom_tags
  )
}
resource "aws_route_table_association" "public1" {
  count = var.create_network_stack ? 1 : 0

  route_table_id = aws_route_table.public[0].id
  subnet_id      = aws_subnet.public1[0].id
}


### public subnet 2
resource "aws_subnet" "public2" {
  count = var.create_network_stack ? 1 : 0

  vpc_id            = aws_vpc.main[0].id
  cidr_block        = var.public_subnet2_cidr
  availability_zone = data.aws_availability_zones.AZs.names[1]

  map_public_ip_on_launch = true

  tags = merge(
    tomap({
      "Name" = "${var.project_name} public subnet 2",
      "kubernetes.io/cluster/${var.project_slug}-cluster" = "shared",
      "kubernetes.io/role/elb" = "1"
    }),
    var.custom_tags
  )
}
resource "aws_route_table_association" "public2" {
  count = var.create_network_stack ? 1 : 0

  route_table_id = aws_route_table.public[0].id
  subnet_id      = aws_subnet.public2[0].id
}

### private subnet 1
resource "aws_subnet" "private1" {
  count = var.create_network_stack ? 1 : 0

  vpc_id            = aws_vpc.main[0].id
  cidr_block        = var.private_subnet1_cidr
  availability_zone = data.aws_availability_zones.AZs.names[0]

  tags = merge(
    tomap({
      "Name" = "${var.project_name} private subnet 1",
      "kubernetes.io/cluster/${var.project_slug}-cluster" = "shared",
      "kubernetes.io/role/internal-elb" = "1"
    }),
    var.custom_tags
  )
}

### private subnet 1 route table
resource "aws_eip" "public1" {
  count = var.create_network_stack ? 1 : 0

  depends_on = [aws_internet_gateway.main[0]]
  domain     = "vpc"

  tags = var.custom_tags
}
resource "aws_nat_gateway" "public1" {
  count = var.create_network_stack ? 1 : 0

  allocation_id = aws_eip.public1[0].id
  subnet_id     = aws_subnet.public1[0].id

  tags = var.custom_tags
}
resource "aws_route_table" "private1" {
  count = var.create_network_stack ? 1 : 0

  vpc_id = aws_vpc.main[0].id

  tags = var.custom_tags
}
resource "aws_route" "private1" {
  count = var.create_network_stack ? 1 : 0

  route_table_id         = aws_route_table.private1[0].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.public1[0].id
}
resource "aws_route_table_association" "private1" {
  count = var.create_network_stack ? 1 : 0

  route_table_id = aws_route_table.private1[0].id
  subnet_id      = aws_subnet.private1[0].id
}

### private subnet 2
resource "aws_subnet" "private2" {
  count = var.create_network_stack ? 1 : 0

  vpc_id            = aws_vpc.main[0].id
  cidr_block        = var.private_subnet2_cidr
  availability_zone = data.aws_availability_zones.AZs.names[1]

  tags = merge(
    tomap({
      "Name" = "${var.project_name} private subnet 2",
      "kubernetes.io/cluster/${var.project_slug}-cluster" = "shared",
      "kubernetes.io/role/internal-elb" = "1"
    }),
    var.custom_tags
  )
}

### private subnet 2 route table
resource "aws_eip" "public2" {
  count = var.create_network_stack ? 1 : 0

  depends_on = [aws_internet_gateway.main[0]]
  domain     = "vpc"

  tags = var.custom_tags
}
resource "aws_nat_gateway" "public2" {
  count = var.create_network_stack ? 1 : 0

  allocation_id = aws_eip.public2[0].id
  subnet_id     = aws_subnet.public2[0].id

  tags = var.custom_tags
}
resource "aws_route_table" "private2" {
  count = var.create_network_stack ? 1 : 0

  vpc_id = aws_vpc.main[0].id

  tags = var.custom_tags
}
resource "aws_route" "private2" {
  count = var.create_network_stack ? 1 : 0

  route_table_id         = aws_route_table.private2[0].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.public2[0].id
}
resource "aws_route_table_association" "private2" {
  count = var.create_network_stack ? 1 : 0

  route_table_id = aws_route_table.private2[0].id
  subnet_id      = aws_subnet.private2[0].id
}

### vpc endpoints
data aws_iam_policy_document "allow_all" {
  statement {
    actions = ["*"]
    principals {
      identifiers = ["*"]
      type        = "AWS"
    }
    resources = ["*"]
  }
}

# Gateway endpoints (S3 and DynamoDB)
resource "aws_vpc_endpoint" "s3" {
  count = var.create_vpc_endpoints && var.create_network_stack ? 1 : 0

  service_name = "com.amazonaws.${data.aws_region.current.name}.s3"
  vpc_id       = aws_vpc.main[0].id
  route_table_ids = [
    aws_route_table.private1[0].id,
    aws_route_table.private2[0].id
  ]
  policy = data.aws_iam_policy_document.allow_all.json

  tags = var.custom_tags
}

resource "aws_vpc_endpoint" "dynamodb" {
  count = var.create_vpc_endpoints && var.create_network_stack ? 1 : 0

  service_name = "com.amazonaws.${data.aws_region.current.name}.dynamodb"
  vpc_id       = aws_vpc.main[0].id
  route_table_ids = [
    aws_route_table.private1[0].id,
    aws_route_table.private2[0].id
  ]
  policy = data.aws_iam_policy_document.allow_all.json

  tags = var.custom_tags
}

# Interface endpoints for SSM
resource "aws_security_group" "vpc_endpoints" {
  count = var.create_vpc_endpoints && var.create_network_stack ? 1 : 0

  name        = "${var.project_slug}-vpc-endpoints-sg"
  description = "Security group for VPC endpoints"
  vpc_id      = aws_vpc.main[0].id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  tags = merge(
    tomap({"Name" = "${var.project_slug}-vpc-endpoints-sg"}),
    var.custom_tags
  )
}

# SSM endpoint
resource "aws_vpc_endpoint" "ssm" {
  count = var.create_vpc_endpoints && var.create_network_stack ? 1 : 0

  vpc_id            = aws_vpc.main[0].id
  service_name      = "com.amazonaws.${data.aws_region.current.name}.ssm"
  vpc_endpoint_type = "Interface"
  subnet_ids        = [aws_subnet.private1[0].id, aws_subnet.private2[0].id]
  security_group_ids = [
    aws_security_group.vpc_endpoints[0].id
  ]
  private_dns_enabled = true
  policy              = data.aws_iam_policy_document.allow_all.json

  tags = merge(
    tomap({"Name" = "${var.project_slug}-ssm-endpoint"}),
    var.custom_tags
  )
}

# EC2 Messages endpoint
resource "aws_vpc_endpoint" "ec2messages" {
  count = var.create_vpc_endpoints && var.create_network_stack ? 1 : 0

  vpc_id            = aws_vpc.main[0].id
  service_name      = "com.amazonaws.${data.aws_region.current.name}.ec2messages"
  vpc_endpoint_type = "Interface"
  subnet_ids        = [aws_subnet.private1[0].id, aws_subnet.private2[0].id]
  security_group_ids = [
    aws_security_group.vpc_endpoints[0].id
  ]
  private_dns_enabled = true
  policy              = data.aws_iam_policy_document.allow_all.json

  tags = merge(
    tomap({"Name" = "${var.project_slug}-ec2messages-endpoint"}),
    var.custom_tags
  )
}

# SSM Messages endpoint
resource "aws_vpc_endpoint" "ssmmessages" {
  count = var.create_vpc_endpoints && var.create_network_stack ? 1 : 0

  vpc_id            = aws_vpc.main[0].id
  service_name      = "com.amazonaws.${data.aws_region.current.name}.ssmmessages"
  vpc_endpoint_type = "Interface"
  subnet_ids        = [aws_subnet.private1[0].id, aws_subnet.private2[0].id]
  security_group_ids = [
    aws_security_group.vpc_endpoints[0].id
  ]
  private_dns_enabled = true
  policy              = data.aws_iam_policy_document.allow_all.json

  tags = merge(
    tomap({"Name" = "${var.project_slug}-ssmmessages-endpoint"}),
    var.custom_tags
  )
}
