resource "aws_s3_bucket" "cur_bucket" {
  bucket = local.s3_bucket_name
}
resource "aws_s3_bucket_acl" "cur_bucket_acl" {
  bucket = aws_s3_bucket.cur_bucket.id
  acl    = "private"
}
resource "aws_s3_bucket_server_side_encryption_configuration" "cur_bucket_encryption_config" {
  bucket = aws_s3_bucket.cur_bucket.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${var.stacklet_saas_account_id}:role/${var.customer_prefix}-cur-read"]
    }
  }
}
resource "aws_iam_policy" "stacklet-shared-cur-s3-access" {
  name   = "stacklet-shared-cur-s3-access"
  path   = "/"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
          "s3:GetBucketLocation",
          "s3:GetObject",
          "s3:ListBucket",
          "s3:ListBucketMultipartUploads",
          "s3:ListMultipartUploadParts",
          "s3:PutObject"
      ],
      "Resource": [
        "arn:aws:s3:::${local.s3_bucket_name}",
        "arn:aws:s3:::${local.s3_bucket_name}/*"
      ]
    }
  ]
}
EOF
}
resource "aws_s3_bucket_policy" "s3-bucket-cur-report-policy" {
  bucket = aws_s3_bucket.cur_bucket.id
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
    }
  ]
}
EOF
}
resource "aws_iam_role" "stacklet-shared-cur-access-role" {
  name                = "stacklet-shared-cur-access"
  assume_role_policy  = data.aws_iam_policy_document.assume_role.json
}
resource "aws_iam_role_policy_attachment" "cur-s3-access" {
  role       = aws_iam_role.stacklet-shared-cur-access-role.name
  policy_arn = aws_iam_policy.stacklet-shared-cur-s3-access.arn
}