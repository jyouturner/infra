variable "region" {
  description = "This is the cloud hosting region where your webapp will be deployed."
}

variable "env" {
  description = "This is the environment where your webapp is deployed. qa, prod, or dev"

}

variable "domain" {
  description = "the domain of our organization"
}

variable "cert_arn" {
  description = "the arn of the certificate"
}

variable "zone_id" {
  description = "the route53 host zone id"
}
