output "public_ip" {
  description = "Contains the public IP address"
  value       = aws_eip.nat_eip_worker.public_ip
}