output "aws_route53_zone_id" {
  description = "route 53 zone"
  value       = aws_route53_zone.domain_zone.zone_id
}
