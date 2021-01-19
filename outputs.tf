output "bucket_name" {
  value = aws_s3_bucket.terraform_statefile.bucket
}

output "dynamodb_name" {
  value = aws_dynamodb_table.terraform_lock.name
}