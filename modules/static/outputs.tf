# Output variable definitions

output "arn" {
  description = "ARN of the bucket"
  value       = aws_s3_bucket.site.arn
}

output "name" {
  description = "Name (id) of the bucket"
  value       = aws_s3_bucket.site.id
}

output "website_endpoint" {
  description = "Domain name of the bucket"
  value       = aws_s3_bucket.site.website_endpoint
}
