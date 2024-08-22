output "vpc_id" {
  description = "ID of the VPC"
  value       = module.network.vpc_id
}

output "public_subnets" {
  description = "The IDs of public subnets"
  value       = module.network.public_subnets
}

# output "master_of_masters_ip" {
#   description = "The MVP of masters control plane"
#   value       = module.control_plane.master_of_masters_ip
# }

# output "master_public_ips" {
#   description = "The IDs of public subnets"
#   value       = module.control_plane.public_ips
# }

output "workers_private_ips" {
  description = "The IDs of private subnets"
  value       = module.worker_nodes.private_ips
}

output "master_instance_ids" {
  description = "master instance ids"
  value       = module.control_plane.master_instance_ids
}

output "worker_instance_ids" {
  description = "worker instance ids"
  value       = module.worker_nodes.worker_instance_ids
}
