resource "aws_security_group" "allow_eice_endpoint" {
  name        = "${var.name}-allow-eice-endpoint"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = var.vpc_id
  tags = {
    "kubernetes.io/cluster/diy-kubernetes" = "owned"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_eice_ingress_ipv4" {
  security_group_id = aws_security_group.allow_eice_endpoint.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
  tags = {
    "kubernetes.io/cluster/diy-kubernetes" = "owned"
  }
}

resource "aws_vpc_security_group_egress_rule" "allow_eice_egress_ipv4" {
  security_group_id = aws_security_group.allow_eice_endpoint.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" 
  tags = {
    "kubernetes.io/cluster/diy-kubernetes" = "owned"
  }
}
 
resource "aws_ec2_instance_connect_endpoint" "ec2_endpoint" {
  subnet_id = var.private_subnet
  security_group_ids = [aws_security_group.allow_eice_endpoint.id]
  tags = {
    Name = var.name
    "kubernetes.io/cluster/diy-kubernetes" = "owned"
  }
}
data "template_file" "user_data_mom" {
  template = "${file("../../scripts/user_data_mom.sh")}"

  vars = {
    TF_LOAD_BALANCER_DNS = var.load_balancer_dns
    TF_LOAD_BALANCER_PORT = var.load_balancer_port
  }
}

resource "aws_key_pair" "master_key" {
  key_name   = "${var.name}-master"
  public_key = var.public_key
  tags = {
    "kubernetes.io/cluster/diy-kubernetes" = "owned"
  }
}

resource "aws_security_group" "allow_master" {
  name        = "${var.name}-allow-master"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = var.vpc_id
  tags = {
    "kubernetes.io/cluster/diy-kubernetes" = "owned"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_ingress_ipv4" {
  security_group_id = aws_security_group.allow_master.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
  tags = {
    "kubernetes.io/cluster/diy-kubernetes" = "owned"
  }
}

resource "aws_vpc_security_group_egress_rule" "allow_egress_ipv4" {
  security_group_id = aws_security_group.allow_master.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" 
  tags = {
    "kubernetes.io/cluster/diy-kubernetes" = "owned"
  }
}
 
# cloud control manager master 
resource "aws_iam_role" "ccm_master_role" {
  name = "ccm_master_role"

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
    "kubernetes.io/cluster/diy-kubernetes" = "owned"
  }
}

resource "aws_iam_policy" "ccm_master_policy1" {
  name   = "ccm_master_policy1"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect   = "Allow",
      Action   = [
          "autoscaling:DescribeAutoScalingGroups",
          "autoscaling:DescribeLaunchConfigurations",
          "autoscaling:DescribeTags",
          "ec2:DescribeInstances",
          "ec2:DescribeRegions",
          "ec2:DescribeInternetGateways",
          "ec2:DescribeRouteTables",
          "ec2:DescribeAccountAttributes",
          "ec2:DescribeSecurityGroups",
          "ec2:DescribeSubnets",
          "ec2:DescribeVolumes",
          "ec2:DescribeAvailabilityZones",
          "ec2:DescribeVpcs"
      ],
      Resource: ["*"]
    }]
  })
  tags = {
    "kubernetes.io/cluster/diy-kubernetes" = "owned"
  }
}

resource "aws_iam_policy" "ccm_master_policy2" {
  name   = "ccm_master_policy2"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect   = "Allow",
      Action   = [
        "ec2:CreateSecurityGroup",
        "ec2:CreateTags",
        "ec2:CreateVolume",
        "ec2:ModifyInstanceAttribute",
        "ec2:ModifyVolume",
        "ec2:AttachVolume",
        "ec2:AuthorizeSecurityGroupIngress",
        "ec2:CreateRoute",
        "ec2:DeleteRoute",
        "ec2:DeleteSecurityGroup",
        "ec2:DeleteVolume",
        "ec2:DetachVolume",
        "ec2:RevokeSecurityGroupIngress",
        "elasticloadbalancing:AddTags",
        "elasticloadbalancing:AttachLoadBalancerToSubnets",
        "elasticloadbalancing:ApplySecurityGroupsToLoadBalancer",
        "elasticloadbalancing:CreateLoadBalancer",
        "elasticloadbalancing:CreateLoadBalancerPolicy",
        "elasticloadbalancing:CreateLoadBalancerListeners",
        "elasticloadbalancing:ConfigureHealthCheck",
        "elasticloadbalancing:DeleteLoadBalancer",
        "elasticloadbalancing:DeleteLoadBalancerListeners",
        "elasticloadbalancing:DescribeLoadBalancers",
        "elasticloadbalancing:DescribeLoadBalancerAttributes",
        "elasticloadbalancing:DetachLoadBalancerFromSubnets",
        "elasticloadbalancing:DeregisterInstancesFromLoadBalancer",
        "elasticloadbalancing:ModifyLoadBalancerAttributes",
        "elasticloadbalancing:RegisterInstancesWithLoadBalancer",
        "elasticloadbalancing:SetLoadBalancerPoliciesForBackendServer",
        "elasticloadbalancing:AddTags",
        "elasticloadbalancing:CreateListener",
        "elasticloadbalancing:CreateTargetGroup",
        "elasticloadbalancing:DeleteListener",
        "elasticloadbalancing:DeleteTargetGroup",
        "elasticloadbalancing:DescribeListeners",
        "elasticloadbalancing:DescribeLoadBalancerPolicies",
        "elasticloadbalancing:DescribeTargetGroups",
        "elasticloadbalancing:DescribeTargetHealth",
        "elasticloadbalancing:ModifyListener",
        "elasticloadbalancing:ModifyTargetGroup",
        "elasticloadbalancing:RegisterTargets",
        "elasticloadbalancing:DeregisterTargets",
        "elasticloadbalancing:SetLoadBalancerPoliciesOfListener",
        "iam:CreateServiceLinkedRole",
        "kms:DescribeKey"
      ],
      Resource: ["*"]
    }]
  })
  tags = {
    "kubernetes.io/cluster/diy-kubernetes" = "owned"
  }
}

resource "aws_iam_role_policy_attachment" "ccm_policy_attachment1" {
  role       = aws_iam_role.ccm_master_role.name
  policy_arn = aws_iam_policy.ccm_master_policy1.arn
}

resource "aws_iam_role_policy_attachment" "ccm_policy_attachment2" {
  role       = aws_iam_role.ccm_master_role.name
  policy_arn = aws_iam_policy.ccm_master_policy2.arn
}

resource "aws_iam_instance_profile" "ccm_master" {
  name = "ccm_master"
  role = aws_iam_role.ccm_master_role.name
  tags = {
    "kubernetes.io/cluster/diy-kubernetes" = "owned"
  }
}

resource "aws_instance" "master_node_0" {
  ami           = "ami-0b27735385ddf20e8"
  instance_type = "t3.small"
  key_name      = aws_key_pair.master_key.key_name
  
  vpc_security_group_ids = [aws_security_group.allow_master.id]
  subnet_id = var.private_subnet
  tags = {
    Name = "${var.name}-master_node_0"
    "kubernetes.io/cluster/diy-kubernetes" = "owned"
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
  user_data = data.template_file.user_data_mom.rendered
  iam_instance_profile = aws_iam_instance_profile.ccm_master.name
} 


resource "aws_instance" "master_node_1" {
  ami           = "ami-0b27735385ddf20e8"
  instance_type = "t3.small"
  key_name      = aws_key_pair.master_key.key_name
  
  vpc_security_group_ids = [aws_security_group.allow_master.id]
  subnet_id = var.private_subnet
  tags = {
    Name = "${var.name}-master_node_1"
    "kubernetes.io/cluster/diy-kubernetes" = "owned"
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
  user_data = file("../../scripts/user_data_master.sh")
  iam_instance_profile = aws_iam_instance_profile.ccm_master.name
} 


resource "aws_instance" "master_node_2" {
  ami           = "ami-0b27735385ddf20e8"
  instance_type = "t3.small"
  key_name      = aws_key_pair.master_key.key_name
  
  vpc_security_group_ids = [aws_security_group.allow_master.id]
  subnet_id = var.private_subnet
  tags = {
    Name = "${var.name}-master_node_2"
    "kubernetes.io/cluster/diy-kubernetes" = "owned"
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
  user_data = file("../../scripts/user_data_master.sh")
  iam_instance_profile = aws_iam_instance_profile.ccm_master.name
} 
