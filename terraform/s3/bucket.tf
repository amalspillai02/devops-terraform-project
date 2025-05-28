# resource "aws_s3_bucket" "static_files" {
#   bucket = "myapp-static-bucket-${random_id.bucket_id.hex}"
#   acl    = "private"

#   versioning {
#     enabled = true
#   }

#   tags = {
#     Name = "My App Bucket"
#   }
# }

# resource "random_id" "bucket_id" {
#   byte_length = 4
# }

