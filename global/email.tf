resource "aws_ses_domain_identity" "domain_identity" {
  domain = aws_route53_zone.domain_zone.name
}

# Note: this may take up to 72 hours to verify
resource "aws_route53_record" "amazonses_verification" {
  zone_id = aws_route53_zone.domain_zone.id
  name    = "_amazonses.${aws_ses_domain_identity.domain_identity.domain}"
  type    = "TXT"
  ttl     = "600"
  records = [aws_ses_domain_identity.domain_identity.verification_token]
}

resource "aws_ses_domain_mail_from" "domain_mail_from" {
  domain           = aws_ses_domain_identity.domain_identity.domain
  mail_from_domain = "mail.${aws_ses_domain_identity.domain_identity.domain}"
}

resource "aws_route53_record" "domain_mail_from_mx" {
  zone_id = aws_route53_zone.domain_zone.id
  name    = aws_ses_domain_mail_from.domain_mail_from.mail_from_domain
  type    = "MX"
  ttl     = "600"

  # The region must match the region in which `aws_ses_domain_identity` is created
  records = ["10 feedback-smtp.${var.region}.amazonses.com"]
}

resource "aws_route53_record" "domain_mail_from_spf" {
  zone_id = aws_route53_zone.domain_zone.id
  name    = aws_ses_domain_mail_from.domain_mail_from.mail_from_domain
  type    = "TXT"
  ttl     = "600"
  records = ["v=spf1 include:amazonses.com -all"]
}

resource "aws_ses_email_identity" "no_reply" {
  email = "no-reply@${aws_ses_domain_identity.domain_identity.domain}"
}

#
# only when you registered domain at Google
#
# This enables Google's domain email forwarding for emails
# https://support.google.com/domains/answer/9428703
# Create this record first to avoid resending the email verification
#resource "aws_route53_record" "google_mx" {
#  zone_id = aws_route53_zone.domain_zone.id
#  type    = "MX"
#  ttl     = "30"
#  name    = ""
#
#  records = [
#    "5 gmr-smtp-in.l.google.com",
#    "10 alt1.gmr-smtp-in.l.google.com",
#    "20 alt2.gmr-smtp-in.l.google.com",
#    "30 alt3.gmr-smtp-in.l.google.com",
#    "40 alt4.gmr-smtp-in.l.google.com",
#  ]
#}