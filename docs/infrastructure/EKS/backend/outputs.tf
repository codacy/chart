output "state_bucket_name" {
  description = "Name of the S3 bucket for Terraform state"
  value       = aws_s3_bucket.state.id
}

output "state_bucket_arn" {
  description = "ARN of the S3 bucket for Terraform state"
  value       = aws_s3_bucket.state.arn
}

output "lock_table_name" {
  description = "Name of the DynamoDB table for Terraform state locking"
  value       = aws_dynamodb_table.lock.id
}

output "lock_table_arn" {
  description = "ARN of the DynamoDB table for Terraform state locking"
  value       = aws_dynamodb_table.lock.arn
}

output "state_kms_key_id" {
  description = "KMS key ID for Terraform state encryption"
  value       = aws_kms_key.state.key_id
}

output "state_kms_key_arn" {
  description = "KMS key ARN for Terraform state encryption"
  value       = aws_kms_key.state.arn
}
