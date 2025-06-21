output "alb_dns_name" {
  value = module.compute.alb_dns_name
}

output "app_s3_bucket_name" {
  value       = module.s3.s3_bucket_name
  description = "The name of the app asset S3 bucket"
}
