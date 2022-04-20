resource "aws_s3_bucket_policy" "allow_access_from_another_account" {
  bucket = aws_s3_bucket.bucket.id
  policy = <<POLICY
{
    "Version": "2008-10-17",
    "Id": "s3-put-delete-only",
    "Statement": [
        {
            "Sid": "1",
            "Effect": "Allow",
            "Principal": "*",
            "Action": [
                "s3:PutObject",
                "s3:DeleteObject",
                "s3:GetObject"
            ],
            "Resource": "arn:aws:s3:::goormedu-clone-bucket/*"
        }
    ]
}
POLICY
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