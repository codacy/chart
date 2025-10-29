# config.tf - terraform and providers configuration

terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  # Set your AWS configuration here. For more information see the terraform
  # provider information: https://registry.terraform.io/providers/hashicorp/aws/latest/docs
  # You might need to set AWS_SDK_LOAD_CONFIG=1 to use your aws credentials file
  region = var.aws_region
}

provider "random" {}
