# config.tf - terraform and providers configuration

terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
  }

  # Using a backend is recommended. See https://www.terraform.io/docs/backends/index.html
  # You may use the provided S3 backend configuration by
  #   1. first running `terraform apply` on the `backend/` directory,
  #   2. getting the state bucket name with `terraform output state_bucket_name`
  #   3. uncommenting the following lines, filling in the required infomation (bucket name and region)
  #      and (re)initializing terraform with `terraform init -reconfigure -backend=true`

  #backend "s3" {
  #  encrypt = true
  #  bucket = "YOUR_S3_BUCKET_NAME_HERE"
  #  dynamodb_table = "codacy-terraform-lock"
  #  region = "YOUR_REGION_HERE"
  #  key = "codacy/cluster.tfstate"
  #}
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = var.custom_tags
  }
}

provider "kubernetes" {
  host                   = aws_eks_cluster.main.endpoint
  cluster_ca_certificate = base64decode(aws_eks_cluster.main.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.eks_cluster_auth.token
}
