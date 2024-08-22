# output "public_ips" {
#   description = "Contains the public IP address"
#   value       = [aws_eip.nat_eip_worker_0.public_ip, aws_eip.nat_eip_worker_1.public_ip]
# }

output "private_ips" {
  description = "Contains the public IP address"
  value       = [aws_instance.worker_node_0.*.private_ip, aws_instance.worker_node_1.*.private_ip] # 
}
output "worker_instance_ids" {
  description = "Workers instance ids"
  value       = [aws_instance.worker_node_0.id, aws_instance.worker_node_1.id] # 
}