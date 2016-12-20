variable "aws_region" {
    description = "AWS region to launch servers."
}

variable "aws_az" {
    description = "AWS availability zone to launch servers."
}

variable "aws_key_name" {
  description = "Name of the SSH keypair to use in AWS."
}

variable "instance_type" {
  description = "Instance type"
}

variable "instance_name" {
  description = "Instance Name"
}

variable "vpc_cidr" {
  description = "VPC /16 network"
}

variable "public_cidr" {
  description = "Public /24 subnet"
}

variable "server_port" {
  description = "The port the server will use for HTTP requests"
}

variable "count" {
  description = "Number of instances to be created"
}

# CentOS 7 (x64)
variable "aws_amis" {
  type = "map"
  default = {
    "us-east-1" = "ami-6d1c2007"
    "us-east-2" = "ami-6a2d760f"
  }
}
