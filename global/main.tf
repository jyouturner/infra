provider "aws" {
  region = var.region
}

# An ACM certificate is needed to apply a custom domain name
# to the API Gateway resource and cloudfront distributions
provider "aws"{
  # need it because of the cloudfront cert
  alias = "east1"
  region = "us-east-1"
}
