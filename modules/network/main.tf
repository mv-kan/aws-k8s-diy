resource "aws_eip" "nat_eip" {
  tags = {
    Name = var.name
    "kubernetes.io/cluster/kubernetes" = "owned"
  }
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.9.0"

  name = var.name
  
  azs = var.azs
  cidr = var.cidr

  public_subnets=var.public_subnets
  create_igw=true 
  tags = {
    "kubernetes.io/cluster/kubernetes" = "owned"
  }
}