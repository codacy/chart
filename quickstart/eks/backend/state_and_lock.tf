# state_and_lock.tf - setup s3 state storage and dynamodb lock table
#                     For more info see https://www.terraform.io/docs/backends/types/s3.html

resource "aws_s3_bucket" "state" {
  bucket = "${var.project_tag}-terraform-state-${random_string.rand.result}"
  acl = "private"

  versioning {
    enabled = true
  }

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_dynamodb_table" "lock" {
  name = "${var.project_tag}-terraform-lock"
  hash_key = "LockID"
  read_capacity = 20
  write_capacity = 20

  attribute {
    name = "LockID"
    type = "S"
  }

  lifecycle {
    prevent_destroy = true
  }
}

resource "random_string" "rand" {
  length = 22
  special = false
  upper = false
  number = false
}