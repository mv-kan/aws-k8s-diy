resource "aws_key_pair" "worker_key" {
  key_name   = "${var.name}-worker"
  public_key = var.public_key
}

resource "aws_security_group" "allow_worker" {
  name        = "${var.name}-allow-worker"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = var.vpc_id
}

resource "aws_vpc_security_group_ingress_rule" "allow_ingress_ipv4" {
  security_group_id = aws_security_group.allow_worker.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_vpc_security_group_egress_rule" "allow_egress_ipv4" {
  security_group_id = aws_security_group.allow_worker.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" 
}

resource "aws_instance" "worker_node_0" {
  ami           = "ami-0b27735385ddf20e8"
  instance_type = "t3.micro"
  key_name      = aws_key_pair.worker_key.key_name
  
  vpc_security_group_ids = [aws_security_group.allow_worker.id]
  subnet_id = var.public_subnet
  tags = {
    Name = "${var.name}-worker_node_0"
  }
  private_dns_name_options {
    enable_resource_name_dns_a_record    = true
    enable_resource_name_dns_aaaa_record = false
    hostname_type                        = "resource-name"
  }
  metadata_options {
    http_tokens = "required"
    http_endpoint = "enabled"
  }
} 