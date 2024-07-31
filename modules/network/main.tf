
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

resource "aws_security_group" "allow_eice_endpoint" {
  name        = "${var.name}-allow-eice-endpoint"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = module.vpc.vpc_id
  tags = {
    "kubernetes.io/cluster/diy-kubernetes" = "owned"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_eice_ingress_ipv4" {
  security_group_id = aws_security_group.allow_eice_endpoint.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
  tags = {
    "kubernetes.io/cluster/diy-kubernetes" = "owned"
  }
}

resource "aws_vpc_security_group_egress_rule" "allow_eice_egress_ipv4" {
  security_group_id = aws_security_group.allow_eice_endpoint.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" 
  tags = {
    "kubernetes.io/cluster/diy-kubernetes" = "owned"
  }
}
 

resource "aws_ec2_instance_connect_endpoint" "ec2_endpoint" {
  subnet_id = module.vpc.private_subnets[0]
  security_group_ids = [aws_security_group.allow_eice_endpoint.id]
  tags = {
    Name = var.name
    "kubernetes.io/cluster/diy-kubernetes" = "owned"
  }
}