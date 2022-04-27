/*
resource "aws_s3_bucket_policy" "allow_access_main_bucket" {
  bucket = aws_s3_bucket.main-bucket.id
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
  bucket = aws_s3_bucket.main-bucket.id

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET", "POST"] # "PUT", "DELETE"
    allowed_origins = ["*"] # ["https://s3-website-test.hashicorp.com"]
    expose_headers  = ["ETag"]
    max_age_seconds = 3000
  }
}

resource "aws_s3_bucket_public_access_block" "main-bucket-public-access-block" {
  bucket              = aws_s3_bucket.main-bucket.id
  block_public_acls   = true
  block_public_policy = true
}

resource "aws_s3_bucket" "main-bucket" {
  bucket = "goormedu-clone-bucket"
}
*/

resource "aws_s3_bucket" "data-bucket" {
  bucket = "goormedu-clone-data-bucket"
}

resource "aws_s3_bucket_policy" "allow_access_data_bucket" {
  bucket = aws_s3_bucket.data-bucket.id
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
                "s3:*"
            ],
            "Resource": "arn:aws:s3:::goormedu-clone-data-bucket/*"
        }
    ]
}
POLICY
}

/*
resource "aws_s3_bucket_cors_configuration" "data-bucket-cors-configuration" {
  bucket = aws_s3_bucket.data-bucket.id

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET", "POST"] # "PUT", "DELETE"
    allowed_origins = ["*"] # ["https://s3-website-test.hashicorp.com"]
    expose_headers  = ["ETag"]
    max_age_seconds = 3000
  }
}
*/

resource "aws_s3_bucket_public_access_block" "data-bucket-public-access-block" {
  bucket              = aws_s3_bucket.data-bucket.id
  block_public_acls   = true
  block_public_policy = true
}