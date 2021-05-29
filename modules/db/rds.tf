
variable "db_identifier" {
  type        = string
  description = "databaes identifier."
}

variable "db_name" {
  type        = string
  description = "databaes name."
}

variable "db_user" {
  type        = string
  description = "databaes user name."
}

variable "db_password" {
  type        = string
  description = "databaes user password."
}

variable "vpc_id" {
  type = string
  description = "vpc id for the database"
}

variable "db_multi_az" {
  type = bool
  description = "whether multizone available"
}

variable "db_instance_type" {
  type = string
  description = "instance type of database"
}

locals {
  tags = {
    team       = "product development"
    email = "devops@trextel.com"
    managed = "terraform"
    env = "dev"
  }
}

data "aws_vpc" "selected" {
  id = var.vpc_id
}

module "security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 4"

  name        = "sg_rds_${var.db_identifier}"
  description = "Complete PostgreSQL example security group"
  vpc_id      = var.vpc_id

  # ingress
  ingress_with_cidr_blocks = [
    {
      from_port   = 5432
      to_port     = 5432
      protocol    = "tcp"
      description = "PostgreSQL access from within VPC"
      cidr_blocks = cidrsubnet(data.aws_vpc.selected.cidr_block, 4, 1)
    },
  ]

  tags = local.tags
}

data "aws_subnet_ids" "private" {
  vpc_id = var.vpc_id

  filter {
    name   ="tag:Name"
    values = ["*private*"]
  }
}

data "aws_subnet_ids" "all" {
  vpc_id = var.vpc_id

}

module "db" {
  source  = "terraform-aws-modules/rds/aws"
  version = "~> 3.0"

  identifier = var.db_identifier
  create_db_option_group    = false
  create_db_parameter_group = false

  # All available versions: https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/CHAP_PostgreSQL.html#PostgreSQL.Concepts
  engine               = "postgres"
  engine_version       = "11.10"
  family               = "postgres11" # DB parameter group
  major_engine_version = "11"         # DB option group
  instance_class       = var.db_instance_type

  allocated_storage     = 20
  max_allocated_storage = 100
  storage_encrypted     = false

  # NOTE: Do NOT use 'user' as the value for 'username' as it throws:
  # "Error creating DB Instance: InvalidParameterValue: MasterUsername
  # user cannot be used as it is a reserved word used by the engine"
  name     = var.db_name
  username = var.db_user
  password = var.db_password
  port     = 5432

  multi_az               = var.db_multi_az
  subnet_ids             = data.aws_subnet_ids.all.ids
  vpc_security_group_ids = [module.security_group.security_group_id]

  maintenance_window              = "Mon:00:00-Mon:03:00"
  backup_window                   = "03:00-06:00"
  enabled_cloudwatch_logs_exports = ["postgresql", "upgrade"]

  backup_retention_period = 0
  skip_final_snapshot     = true
  deletion_protection     = false

  tags = local.tags

}
