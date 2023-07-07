resource "aws_s3_bucket" "cur_bucket" {
  count  = contains(var.clouds, "aws") ? 1 : 0
  bucket = local.s3_bucket_name
}

resource "aws_s3_bucket_server_side_encryption_configuration" "cur_bucket_encryption_config" {
  count  = contains(var.clouds, "aws") ? 1 : 0
  bucket = aws_s3_bucket.cur_bucket[0].bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
resource "aws_s3_bucket_policy" "s3-bucket-cur-report-policy" {
  count  = contains(var.clouds, "aws") ? 1 : 0
  bucket = aws_s3_bucket.cur_bucket[0].id
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "billingreports.amazonaws.com"
      },
      "Action": [
        "s3:GetBucketAcl",
        "s3:GetBucketPolicy"
      ],
      "Resource":"arn:aws:s3:::${local.s3_bucket_name}"
    },
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "billingreports.amazonaws.com"
      },
      "Action": "s3:PutObject",
      "Resource": "arn:aws:s3:::${local.s3_bucket_name}/*"
    },
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::${var.stacklet_saas_account_id}:role/${var.customer_prefix}-cur-read"
      },
      "Action": [
        "s3:ListBucket"
      ],
      "Resource": [
        "arn:aws:s3:::${local.s3_bucket_name}"
      ]
    },
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::${var.stacklet_saas_account_id}:role/${var.customer_prefix}-cur-read"
      },
      "Action": [
        "s3:GetObject"
      ],
      "Resource": [
        "arn:aws:s3:::${local.s3_bucket_name}/*"
      ]
    }
  ]
}
EOF
}

resource "aws_s3_bucket_public_access_block" "block_public_access" {
  count  = contains(var.clouds, "aws") ? 1 : 0
  bucket = aws_s3_bucket.cur_bucket[0].id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_ownership_controls" "bucket_ownership" {
  count  = contains(var.clouds, "aws") ? 1 : 0
  bucket = aws_s3_bucket.cur_bucket[0].id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}
