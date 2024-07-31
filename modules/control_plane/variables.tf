variable "name" {
  description = "Name to be used on all the resources as identifier"
  type        = string
  default     = ""
}

variable "public_key" {
    description = "Public key that can be used for connecting with ec2"
    type = string
    default = ""
}

variable "vpc_id" {
    description = "ID of VPC where to deploy control plane"
    type = string
    default = ""
}

variable "private_subnet" {
    description = "Private subnet where to put ec2 instances"
    type = string
    default = ""
}
 
 variable "load_balancer_dns" {
    description = "load_balancer_dns"
    type = string
    default = ""
}
 
 variable "load_balancer_port" {
    description = "load_balancer_port"
    type = string
    default = ""
}
 
 