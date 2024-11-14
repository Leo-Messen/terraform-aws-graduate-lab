output "available_azs" {
  value = data.aws_availability_zones.available_azs.names
}

output "s3_webfiles_bucket_arn" {
  value = module.s3_bucket.s3_bucket_arn
}

output "s3_webfiles_bucket_id" {
  value = module.s3_bucket.s3_bucket_id
}
