output "public_ips" {
  description = "Contains the public IP address"
  value       = [aws_eip.nat_eip_worker_0.public_ip, aws_eip.nat_eip_worker_1.public_ip]
}