variable "db_password" {
  description = "Database password"
  type        = string
  sensitive   = true
  default     = "ChangeMe123!"
}

# Root outputs.tf
output "vpc_id" {
  value = module.network.vpc_id
}

output "ec2_public_ip" {
  value = module.compute.ec2_public_ip
}

output "s3_bucket_name" {
  value = module.s3.bucket_name
}

output "rds_endpoint" {
  value = module.database.rds_endpoint
}