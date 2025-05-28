output "bucket_name" {
  value = aws_s3_bucket.static_files.bucket
}

output "bucket_arn" {
  value = aws_s3_bucket.static_files.arn
}