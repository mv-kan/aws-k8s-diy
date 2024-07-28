output "vpc_id" {
  description = "ID of the VPC"
  value       = module.network.vpc_id
}

output "public_subnets" {
  description = "The IDs of public subnets"
  value       = module.network.public_subnets
}

output "master_public_ip" {
  description = "The IDs of public subnets"
  value       = module.control_plane.public_ip
}

output "workers_public_ips" {
  description = "The IDs of public subnets"
  value       = module.worker_nodes.public_ips
}