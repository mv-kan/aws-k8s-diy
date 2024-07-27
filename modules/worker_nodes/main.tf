resource "aws_key_pair" "worker_key" {
  key_name   = "${var.name}-worker"
  public_key = var.public_key
  tags = {
    "kubernetes.io/cluster/kubernetes" = "owned"
  }
}

resource "aws_security_group" "allow_worker" {
  name        = "${var.name}-allow-worker"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = var.vpc_id
  tags = {
    "kubernetes.io/cluster/kubernetes" = "owned"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_ingress_ipv4" {
  security_group_id = aws_security_group.allow_worker.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
  tags = {
    "kubernetes.io/cluster/kubernetes" = "owned"
  }
}

resource "aws_vpc_security_group_egress_rule" "allow_egress_ipv4" {
  security_group_id = aws_security_group.allow_worker.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" 
  tags = {
    "kubernetes.io/cluster/kubernetes" = "owned"
  }
}

resource "aws_eip" "nat_eip_worker" {
  tags = {
    Name = "${var.name}-worker-ip"
    "kubernetes.io/cluster/kubernetes" = "owned"
  }
}

resource "aws_eip_association" "eip_assoc" {
  instance_id   = aws_instance.worker_node_0.id
  allocation_id = aws_eip.nat_eip_worker.id
}

# cloud control manager worker 
resource "aws_iam_role" "ccm_worker_role" {
  name = "ccm_worker_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })
  tags = {
    "kubernetes.io/cluster/kubernetes" = "owned"
  }
}
resource "aws_iam_policy" "ccm_worker_policy" {
  name   = "ccm_worker"
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ec2:DescribeInstances",
                "ec2:DescribeRegions",
                "ecr:GetAuthorizationToken",
                "ecr:BatchCheckLayerAvailability",
                "ecr:GetDownloadUrlForLayer",
                "ecr:GetRepositoryPolicy",
                "ecr:DescribeRepositories",
                "ecr:ListImages",
                "ecr:BatchGetImage"
            ],
            "Resource": ["*"]
        }
    ]
})
  tags = {
    "kubernetes.io/cluster/kubernetes" = "owned"
  }
}

resource "aws_iam_role_policy_attachment" "ccm_policy_attachment1" {
  role       = aws_iam_role.ccm_worker_role.name
  policy_arn = aws_iam_policy.ccm_worker_policy.arn
  
}

resource "aws_iam_instance_profile" "ccm_worker" {
  name = "ccm_worker"
  role = aws_iam_role.ccm_worker_role.name
  tags = {
    "kubernetes.io/cluster/kubernetes" = "owned"
  }
} 

resource "aws_instance" "worker_node_0" {
  ami           = "ami-0b27735385ddf20e8"
  instance_type = "t3.small"
  key_name      = aws_key_pair.worker_key.key_name
  
  vpc_security_group_ids = [aws_security_group.allow_worker.id]
  subnet_id = var.public_subnet
  tags = {
    Name = "${var.name}-worker_node_0"
    "kubernetes.io/cluster/kubernetes" = "owned"
  }
  private_dns_name_options {
    enable_resource_name_dns_a_record    = true
    enable_resource_name_dns_aaaa_record = false
    hostname_type                        = "ip-name"
  }
  metadata_options {
    http_tokens = "required"
    http_endpoint = "enabled"
  }
  user_data = file("../../scripts/user_data_worker.sh")
  iam_instance_profile = aws_iam_instance_profile.ccm_worker.name
} 