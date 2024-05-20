#######################
# S3 state
#######################
locals {
  project = "playground-k8s"
}

resource "aws_s3_bucket" "backend-tracking" {
  bucket = "${local.project}-terraform-state"
}

resource "aws_s3_bucket_versioning" "backend-tracking" {
  bucket = aws_s3_bucket.backend-tracking.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "backend-tracking" {
  bucket = aws_s3_bucket.backend-tracking.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}


#######################
# DynamoDB state lock
#######################

resource "aws_dynamodb_table" "tf-state-lock" {
  name         = "terraform-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}
