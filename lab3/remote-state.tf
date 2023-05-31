resource "aws_s3_bucket" "s3-remote-state" {
  bucket = var.s3-remote-state-bucket-name
  lifecycle {
    prevent_destroy = true
  }
  tags = {
    name = var.s3-remote-state-bucket-name
  }
}

resource "aws_s3_bucket_versioning" "s3-remote-state-versioning-enabled" {
  bucket = var.s3-remote-state-bucket-name
  versioning_configuration {
    status = "Enabled"
  }
  depends_on = [aws_s3_bucket.s3-remote-state]
}

resource "aws_dynamodb_table" "dynamodb-remote-state" {
  name         = "dynamodb-remote-state-table"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}

terraform {
  backend "s3" {
    bucket         = "remote-state-lock-iti"
    key            = "iti-tera/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "dynamodb-remote-state-table"
    encrypt        = true
  }
}