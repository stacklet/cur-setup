output "assume_role_arn" {
    value = aws_iam_role.stacklet-shared-cur-access-role.arn
}
output "s3_bucket_path" {
    value = aws_s3_bucket.cur_bucket.bucket
}