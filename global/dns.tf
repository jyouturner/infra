# Define the primary zone for our domain
resource "aws_route53_zone" "domain_zone" {
  name = var.domain
}

# Create the nameservers for our domain
resource "aws_route53_record" "domain_nameservers" {
  zone_id         = aws_route53_zone.domain_zone.zone_id
  name            = aws_route53_zone.domain_zone.name
  type            = "NS"
  ttl             = "30"
  allow_overwrite = true

  records = [
    aws_route53_zone.domain_zone.name_servers.0,
    aws_route53_zone.domain_zone.name_servers.1,
    aws_route53_zone.domain_zone.name_servers.2,
    aws_route53_zone.domain_zone.name_servers.3,
  ]
}
