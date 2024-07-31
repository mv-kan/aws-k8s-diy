
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.9.0"

  name = var.name
  
  azs = var.azs
  cidr = var.cidr

  public_subnets=var.public_subnets
  private_subnets=var.private_subnets
  # create_igw=true 
  enable_nat_gateway     = true
  single_nat_gateway     = true
  # one_nat_gateway_per_az = false
  tags = {
    "kubernetes.io/cluster/diy-kubernetes" = "owned"
  }
}

resource "aws_ec2_instance_connect_endpoint" "ec2_endpoint" {
  subnet_id = module.vpc.private_subnets[0]
  tags = {
    "kubernetes.io/cluster/diy-kubernetes" = "owned"
  }
}