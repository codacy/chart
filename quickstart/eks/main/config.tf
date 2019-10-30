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
  #  key = "codacy-beta/cluster.tfstate"
  #}
}

provider "aws" {
  # Set your AWS configuration here. For more information see the terraform
  # provider information: https://www.terraform.io/docs/providers/aws/index.html
  # You might need to set AWS_SDK_LOAD_CONFIG=1 to use your aws credentials file
  region = "eu-west-1"
  version = "~> 2.33"
}
