provider "aws" {
  region = "us-east-1"
}

resource "random_integer" "random" {
  min = 10000000
  max = 99999999
}

resource "aws_s3_bucket" "terraform_statefile" {
  bucket = "terraform-tfstate-files-remote-s3-${random_integer.random.result}"
  acl    = "private"

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

resource "aws_s3_bucket_public_access_block" "terraform_statefile" {
  bucket                  = aws_s3_bucket.terraform_statefile.id
  block_public_acls       = true
  block_public_policy     = true
  restrict_public_buckets = true
  ignore_public_acls      = true
}

resource "aws_dynamodb_table" "terraform_lock" {
  name         = "terraform-state-locking-ddb"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}