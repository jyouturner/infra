# Global Infrastructure

For a company or organization, let's say, "netflex.com", this is where we set up those important company-level resources.

First, register your domain at route53. 

## DNS


## SSL CERT


## Email


## How to work

````
cd /infra
terraform init
terraform plan -out global.plan
terraform apply dev.plan
````