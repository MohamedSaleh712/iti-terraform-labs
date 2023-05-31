module "vpc-caller" {
  source   = "./vpc-module"
  vpc-cidr = var.vpc-cidr
  vpc-name = var.vpc-name
  igw-name = var.igw-name
}

module "subnet-caller" {
  source             = "./subnet-module"
  vpc_id             = module.vpc-caller.vpc_id
  for_each           = var.subnets
  subnet-cidr-blocks = each.value[0]
  subnet-AZ          = each.value[1]
  subnet-name        = each.key
}

module "route-table-module-public-1"{
  source = "./route-table-module"
  vpc_id             = module.vpc-caller.vpc_id
  gateway_id= module.vpc-caller.igw_id
  subnet_id= module.subnet-caller["public_subnet_1"].subnet-id-output
}

module "route-table-module-public-2"{
  source = "./route-table-module"
  vpc_id             = module.vpc-caller.vpc_id
  gateway_id= module.vpc-caller.igw_id
  subnet_id= module.subnet-caller["public_subnet_2"].subnet-id-output
}

module "route-table-module-private-1"{
  source = "./route-table-module"
  vpc_id             = module.vpc-caller.vpc_id
  nat_gateway_id= aws_nat_gateway.NAT-gateway.id
  subnet_id= module.subnet-caller["private_subnet_1"].subnet-id-output
}

module "route-table-module-private-2"{
  source = "./route-table-module"
  vpc_id             = module.vpc-caller.vpc_id
  nat_gateway_id= aws_nat_gateway.NAT-gateway.id
  subnet_id= module.subnet-caller["private_subnet_2"].subnet-id-output
}

module "ec2_instances" {
    source = "./EC2-module"
    vpc_id = module.vpc-caller.vpc_id
    my_subnets_ids = [
  module.subnet-caller["public_subnet_1"].subnet-id-output,
  module.subnet-caller["public_subnet_2"].subnet-id-output,
  module.subnet-caller["private_subnet_1"].subnet-id-output,
  module.subnet-caller["private_subnet_2"].subnet-id-output
]
    private_lb_dns = module.LoadBalancer-caller.private_lb_dns
}

module "LoadBalancer-caller" {
  source = "./LoadBalancer-module"
    my_subnets_ids = [
  module.subnet-caller["public_subnet_1"].subnet-id-output,
  module.subnet-caller["public_subnet_2"].subnet-id-output,
  module.subnet-caller["private_subnet_1"].subnet-id-output,
  module.subnet-caller["private_subnet_2"].subnet-id-output
]
    vpc_id = module.vpc-caller.vpc_id
    Public_instances = module.ec2_instances.Pub_instances_ids
    Private_instances = module.ec2_instances.Private_instances_ids
}
