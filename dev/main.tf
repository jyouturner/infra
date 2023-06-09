provider "aws" {
  region = var.region
}


module "dev_vpc" {
  source = "../modules/network"
  eks_cluster_name            = "dev-eks"
  env     = "dev"
  main_network_block      = "172.18.0.0/16"
  subnet_prefix_extension = 4
  zone_offset             = 8
}

module "dev_db" {
  source = "../modules/db"
  db_identifier = "app-db-${var.env}"
  db_name = "app"
  db_user = "postgres"
  db_password = "...!"
  db_multi_az = false
  db_instance_type = "db.t3.small"
  vpc_id = module.dev_vpc.vpc_id
}

module "dev_eks" {
  source = "../modules/eks"
  
  # eks
  admin_users                              = ["jyou"]
  developer_users                          = ["jyou"]
  asg_instance_types                       = ["t3.small", "t2.small"]
  autoscaling_minimum_size_by_az           = 1
  autoscaling_desired_size_by_az           = 1
  autoscaling_maximum_size_by_az           = 1
  autoscaling_average_cpu                  = 50
  spot_termination_handler_chart_name      = "aws-node-termination-handler"
  spot_termination_handler_chart_repo      = "https://aws.github.io/eks-charts"
  spot_termination_handler_chart_version   = "0.9.1"
  spot_termination_handler_chart_namespace = "kube-system"
  vpc_id = module.dev_vpc.vpc_id
  private_subnets = module.dev_vpc.private_subnets
  cluster_name = "dev-eks"
  available_azs = module.dev_vpc.available_azs
  #
  # the name of the company or the organization
  #
  org_name = "product-development"
  
  # namespace
  namespaces = ["demo", "app"]
  
}
