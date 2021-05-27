variable "site_name" {
  description = "This is the name of the static web site."
}
variable "env" {
  description = "This is the environment where your webapp is deployed. qa, prod, or dev"
}

variable "domain" {
  description = "This is the domain of the organization"
}

variable "cert_arn" {
  description = "the arn of the certificate"
}

variable "zone_id" {
  description = "the route53 host zone id"
}