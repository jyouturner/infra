# Indicate to Terraform to use S3 bucket to maintain the state
# 
# can not use variable here. either set the value in the tf file, or pass from the command line
# run the terraform init by
# terraform init \
# -backend-config="bucket=${TFSTATE_BUCKET}" \
# -backend-config="key=${TFSTATE_KEY}" \
# -backend-config="region=${TFSTATE_REGION}"
#
terraform {
  backend "s3" {
      region = "us-west-2"
      bucket = "app-infra-state"
      key = "global"
  }
}