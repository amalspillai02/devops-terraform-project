resource "aws_s3_bucket" "static_files" {
  bucket = "myapp-static-bucket-${random_id.bucket_id.hex}"
  tags = {
    Name = "My App Bucket"
  }
}

resource "aws_s3_bucket_versioning" "static_files_versioning" {
  bucket = aws_s3_bucket.static_files.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_acl" "static_files_acl" {
  bucket = aws_s3_bucket.static_files.id
  acl    = "private"
  depends_on = [aws_s3_bucket_ownership_controls.s3_bucket_acl_ownership]
}

resource "aws_s3_bucket_ownership_controls" "s3_bucket_acl_ownership" {
  bucket = aws_s3_bucket.static_files.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "random_id" "bucket_id" {
  byte_length = 4
}
