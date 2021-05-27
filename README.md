
# Infrastructure

This repo contains the Terraform code for our infrastruture.

## Local Working Station

To get it running, the easist way probably is using the local docker container as your working station. There are 3 files:

1. Dockerfile

it is a Linux container (Ubuntu), with all the useful tools installed including

* git, curl, wget
* terraform
* AWS Cli
* Kubectl
* 

2. work_station.env

AWS credentials in the work_station.env file, for the AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY

3. docker-compose.yml

It simply reads the work_station.env into Env of the docker container, and map local folder to /infra

````
docker-compose build
docker-compose up
docker exec -it [container name] /bin/bash
````

## Terraform Structure

In this project, we are managing the infrastrcture of the whole company or organization.

````
dev
    - the infra of your devevelopment environments.
staging
    - the infra of your staging environment
prod
    - of course, the production
global
    - DNS, email server etc.
    - The reason that we don't have them in the "prod" because most of time, once those resources are created we don't change them much (well, DNS can be exception), and we really don't want to screw up this part.
````

Each of the above folders declares the resources of the particular environments, through "main.tf", with variables in "variables.tf".

The real work is in the "modules"

````
modules
    - this is where all the resource Terraform modules exist, sort of like the "libraries"
    - everything is here, networking (VPC), computing (EC2), EKS, static web site (by S3)
````

## Git Branches

Infra-as-code is not code, for example, "dev" environment is legit environment, often different from "prod" environment. That is why we have "dev", "staging", "prod" in the same level.

Source code wise, we most likely only need to have one "master" branch. That is where everything becomes official, and where you normally operate from, like below:

````
git clone ...
cd dev
terraform init
terraform plan
terraform apply
cd ..
cd prod
terraform init
terraform plan
terraform apply
````


## Development of infra

If you ever need to develop or change any resources, for example, add new resource like SNS, or RDS, can fllow this procedure:

1. create a new feature branch.

2. develop, change stuff at your local.

3. launch the workstation. Because it maps your local folder to /infra in the container, you can edit through your IDE for example Visual Code, and experiment in the container.

4. commit, code review, and merge into master

5. switch to master branch

6. update and apply to dev

7. update and apply to prod

## Deployment

I don't think CI/CD is much useful in terms of manaing infrastructure (probably expect Lambda with Serverless Framework, we will talk about it next). We'd manage manually using Terraform CLI.

## Terraform vs Serverless Framework

Serverless Framework is a wonderful way to manage Lambda. It is more developer friendly than Terraform. These two things can actually live nicely together:

1. Lambda centric resources will be managed by Serverless Framework (i.e., the serverless.yml in your Lambda project)

2. Resource that may be used by Lambda, but not completely owned by the Lambda function, will be managed by Terraform. 

Here is the example:

Say we have a Lambda function, the function will process files from a S3 bucket. The files are put in to this S3 bucket by other systems. In this case, we'd treat the S3 bucket as "existing bucket" (means, Serverless framework will not try to "create" it), and use Terraform to manage it.

On the other side, if this Lambda also store some sort of process status in a Dynamo table, then, we can have serverless framework handle it.

## Terraform State

We use S3 bucket to store the Terraform state file. This bucket is manually created. This way, we can keep the shared state.

For example, in each of the "dev", "prod", or "global" folder, you see a file "backend.tf", that is to define the "backend" of Terraform state.

````
terraform {
  backend "s3" {
      region = "us-west-2"
      bucket = "terraform-boilerplate-state"
      key = "global"
  }
}
````

This means, we will use the S3 bucket "terraform-boilerplate-state" to store the Terraform state file, and the "gloabl" resources are in the "global" folder within that bucket.

## README

At each folder, we have README.md file for detailed documentation.

## Tagging

It is always good practice to tag those resources. Particularily below tags

1. managed: can be Terraform, Serverless Framework, or DevOps (means Manually)

2. Team:

3. Project:

4. Email:

