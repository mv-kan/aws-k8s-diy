provider "aws" {
  region = "eu-north-1"

  allowed_account_ids = var.allowed_account_ids
}

terraform {
  backend "s3" {
    bucket  = "aws-k8s-diy"
    key     = "terraform/terraform.tfstate"
    region  = "eu-north-1"
    encrypt = true
  }
}

module "network" {
  source = "../../modules/network"

  name = var.name

  cidr = var.cidr
  azs  = var.azs

  public_subnets = var.public_subnets
  private_subnets = var.private_subnets
}

module "control_plane" {
    source = "../../modules/control_plane"

    name = var.name
    private_subnet = module.network.private_subnets[0]
    vpc_id = module.network.vpc_id
    public_key = var.public_key
    depends_on = [ module.network ]
}

module "worker_nodes" {
    source = "../../modules/worker_nodes"

    name = var.name
    private_subnet = module.network.private_subnets[0]
    vpc_id = module.network.vpc_id
    public_key = var.public_key
    depends_on = [ module.network ]
}