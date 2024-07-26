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

variable "public_subnet" {
    description = "Public subnet where to put ec2 instances"
    type = string
    default = ""
}