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
  # ingress
  dns_base_domain               = var.domain
  ingress_gateway_chart_name    = "nginx-ingress"
  ingress_gateway_chart_repo    = "https://helm.nginx.com/stable"
  ingress_gateway_chart_version = "0.5.2"
  ingress_gateway_annotations = {
    "controller.service.annotations.service\\.v1beta1\\.kubernetes\\.io/aws-load-balancer-connection-idle-timeout" = "60",
    "controller.service.annotations.service\\.v1beta1\\.kubernetes\\.io/aws-load-balancer-type"                    = "elb"
  }
  cert_arn = var.cert_arn
  # namespace
  namespaces = ["demo", "customer-portal"]
  # subdomains
  deployments_subdomains=["demo", "customer-portal"] # to be prefixed before dns_base_domain (e.g. sample.eks.singh.cl or api.eks.singh.cl), and handled by Ingress rules defined by each Application Helm Chart

}
