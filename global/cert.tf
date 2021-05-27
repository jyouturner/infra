
resource "aws_acm_certificate" "cert" {
  provider = aws.east1
  domain_name       = aws_route53_zone.domain_zone.name
  validation_method = "DNS"

  subject_alternative_names = [
    "*.${aws_route53_zone.domain_zone.name}",
  ]

  lifecycle {
    create_before_destroy = true
  }
}

#
# didn't work, stuck at pending validation, even after I manally clicked to create the cname record
#
# AWS needs to verify that we own the domain; to prove this we will create a
# DNS entry with a validation code
 resource "aws_route53_record" "cert_validation_record" {
  name    = tolist(aws_acm_certificate.cert.domain_validation_options)[0].resource_record_name
  type    = tolist(aws_acm_certificate.cert.domain_validation_options)[0].resource_record_type
  records = [tolist(aws_acm_certificate.cert.domain_validation_options)[0].resource_record_value]
  zone_id = aws_route53_zone.domain_zone.zone_id
  ttl     = 60
}

resource "aws_acm_certificate_validation" "cert_validation" {
  # cert must be in us-east-1 to be used with aws cloud front
  provider = aws.east1
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [aws_route53_record.cert_validation_record.fqdn]
}

output "aws_acm_certificate_cert_arn" {
  value = aws_acm_certificate.cert.arn
}