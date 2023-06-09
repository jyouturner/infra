# create some variables
variable "eks_cluster_name" {
  type        = string
  description = "EKS cluster name."
}
variable "env" {
  type        = string
  description = "AWS tag to indicate environment name of each infrastructure object."
}

variable "main_network_block" {
  type        = string
  description = "Base CIDR block to be used in our VPC."
}
variable "subnet_prefix_extension" {
  type        = number
  description = "CIDR block bits extension to calculate CIDR blocks of each subnetwork."
}
variable "zone_offset" {
  type        = number
  description = "CIDR block bits extension offset to calculate Public subnets, avoiding collisions with Private subnets."
}