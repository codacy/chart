# config.tf - terraform and providers configuration

terraform {
  required_version = "~> 0.12"
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
  # Set your AWS configuration here. For more information see the terraform
  # provider information: https://www.terraform.io/docs/providers/aws/index.html
  # You might need to set AWS_SDK_LOAD_CONFIG=1 to use your aws credentials file
  region  = var.aws_region
  version = "~> 2.33"
}

provider "kubernetes" {
  host                   = aws_eks_cluster.main.endpoint
  cluster_ca_certificate = base64decode(aws_eks_cluster.main.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.eks_cluster_auth.token
  # Change `load_config_file` to `true` if,  when reapplying, you obtain an error with content similar to:
  #
  # Error: configmaps "aws-auth" is forbidden: User "system:anonymous" cannot get resource "configmaps" in API group "" in the namespace "kube-system"
  #
  load_config_file       = false
  version                = "~> 1.5"
}
