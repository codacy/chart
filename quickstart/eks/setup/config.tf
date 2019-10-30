# config.tf - terraform and providers configuration

terraform {
  required_version = "~> 0.12"
  # Using a backend is recommended. See https://www.terraform.io/docs/backends/index.html
  # You may used the provided S3 backend configuration by first running `terraform apply`
  # on the `backend/` directory, uncommenting the following lines, and (re)initializing terraform
  # with `terraform init -reconfigure -backend=true`

  #backend "s3" {
  #  encrypt = true
  #  # note that a random string is appended to the S3 bucket name to make it unique
  #  # you should change this value on the backend and also set it here
  #  bucket = "codacy-beta-terraform-state-YOUR_RANDOM_STRING_HERE"
  #  dynamodb_table = "codacy-beta-terraform-lock"
  #  region = "eu-west-1"
  #  key = "codacy-beta/config.tfstate"
  #}
}

provider "aws" {
  # Set your AWS configuration here. For more information see the terraform
  # provider information: https://www.terraform.io/docs/providers/aws/index.html
  # You might need to set AWS_SDK_LOAD_CONFIG=1 to use your aws credentials file
  region = "eu-west-1"
  version = "~> 2.33"
}

provider "helm" {
  version = "~> 0.10"

  install_tiller  = "true"
  service_account = kubernetes_service_account.tiller.metadata.0.name

  kubernetes {
    host = data.aws_eks_cluster.main.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.main.certificate_authority.0.data)
    token = data.aws_eks_cluster_auth.main.token
    load_config_file = false
  }
}

provider "kubernetes" {
  version = "~> 1.9"
  host = data.aws_eks_cluster.main.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.main.certificate_authority.0.data)
  token = data.aws_eks_cluster_auth.main.token
  load_config_file = false
}


provider "null" {
  version = "~> 2.1"
}

provider "template" {
  version = "~> 2.1"
}

