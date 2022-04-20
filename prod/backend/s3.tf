resource "aws_s3_bucket_policy" "allow_access_from_another_account" {
  bucket = aws_s3_bucket.bucket.id

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["*"] # ["PUT", "POST"]
    allowed_origins = ["*"] # ["https://s3-website-test.hashicorp.com"]
    expose_headers  = ["ETag"]
    # max_age_seconds = 3000
  }
}

resource "aws_s3_bucket_cors_configuration" "bucket-cors-configuration" {
  bucket = aws_s3_bucket.bucket.id

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["*"]
    allowed_origins = ["*"]
    expose_headers  = ["ETag"]
    max_age_seconds = 3000
  }
}

resource "aws_s3_bucket_public_access_block" "bucket-public-access-block" {
  bucket = aws_s3_bucket.bucket.id

  block_public_acls   = true
  block_public_policy = true
}

resource "aws_s3_bucket" "bucket" {
  bucket = "goormedu-clone-bucket"
}