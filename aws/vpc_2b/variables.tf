variable "aws_region" {}
variable "aws_az" {}
variable "aws_key_name" {}
variable "instance_type" {}
variable "instance_name" {}
variable "vpc_cidr" {}
variable "public_cidr" {}
variable "private_cidr" {}
variable "server_port" {}
variable "root_volume_size" {}
variable "volume_delete_on_termination" {}
variable "count" {}

# CentOS 7 (x64)
variable "aws_amis" {
  type = "map"
  default = {
    "us-east-1" = "ami-6d1c2007"
    "us-east-2" = "ami-6a2d760f"
  }
}
