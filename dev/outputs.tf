output "dev_website_bucket_arn" {
  description = "ARN of the bucket"
  value       = module.website_dev_s3_bucket.arn
}

output "dev_website_bucket_name" {
  description = "Name (id) of the bucket"
  value       = module.website_dev_s3_bucket.name
}

output "dev_website_endpoint" {
  description = "Domain name of the bucket"
  value       = module.website_dev_s3_bucket.website_endpoint
}

output "demo_website_bucket_arn" {
  description = "ARN of the bucket"
  value       = module.website_demo_s3_bucket.arn
}

output "demo_website_bucket_name" {
  description = "Name (id) of the bucket"
  value       = module.website_demo_s3_bucket.name
}

output "demo_website_endpoint" {
  description = "Domain name of the bucket"
  value       = module.website_demo_s3_bucket.website_endpoint
}

output "dev_vpc" {
  description = "dev vpc id"
  value = module.dev_vpc.vpc_id
}