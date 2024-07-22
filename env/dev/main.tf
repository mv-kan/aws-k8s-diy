provider "aws" {
  region = "eu-north-1"

  allowed_account_ids = var.allowed_account_ids
}

module "network" {
  source = "../../modules/network"

  name = var.name

  cidr = var.cidr
  azs  = var.azs

  public_subnets = var.public_subnets
}

module "control_plane" {
    source = "../../modules/control_plane"

    name = var.name
    public_subnet = module.network.public_subnets[0]
    vpc_id = module.network.vpc_id
    public_key = var.public_key
}