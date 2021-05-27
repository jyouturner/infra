output "vpc_id"{
    description = "vpc id"
    value = module.vpc.vpc_id
}

output "private_subnets"{
    description = "private subnets"
    value = module.vpc.private_subnets
}

output "public_subnets"{
    description = "public subnets"
    value = module.vpc.public_subnets
}

output "available_azs" {
    description = "avalability zones of vpc"
    value = module.vpc.azs
}