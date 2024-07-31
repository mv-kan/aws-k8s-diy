# output "public_ips" {
#   description = "Contains the public IP address"
#   value       = [aws_eip.nat_eip_master_0.public_ip, aws_eip.nat_eip_master_1.public_ip, aws_eip.nat_eip_master_2.public_ip]
# }

# output "master_of_masters_ip" {
#   description = "Master of masters, where you make all configuration"
#   value       = [aws_eip.nat_eip_master_0.public_ip]
# }

# mom - master of masters
output "mom_instance_id" {
  description = "Master of masters instance id"
  value       = [aws_instance.master_node_0.id]
}

output "master_instance_ids" {
  description = "Master of masters, where you make all configuration"
  value       = [aws_instance.master_node_0.id, aws_instance.master_node_1.id, aws_instance.master_node_2.id]
}