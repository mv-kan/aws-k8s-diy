output "vpc_id" {
  description = "ID of the VPC"
  value       = module.network.vpc_id
}

output "public_subnets" {
  description = "The IDs of public subnets"
  value       = module.network.public_subnets
}