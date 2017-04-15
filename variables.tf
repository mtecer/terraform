//variable "aws_access_key" {
//    decscription = "AWS Access Key"
//    default = ""
//}
//
//variable "aws_secret_key" {
//    description = ""
//    default = ""
//}

variable "aws_region" {
    description = "AWS region to launch servers."
    default = "us-east-2"
}

variable "aws_az" {
    description = "AWS availability zone to launch servers."
    default = "us-east-2a"
}

variable "aws_key_name" {
  description = "Name of the SSH keypair to use in AWS."
  default = "mtecer"
}

variable "subnet_id" {
  description = "Subnet ID to use in VPC"
  default = "subnet-b9353893"
}

variable "instance_type" {
  description = "Instance type"
  default = "t2.micro"
}

variable "instance_name" {
  description = "Instance Name"
  default = "mtecer_instance"
}

# CentOS 7 (x64)
variable "aws_amis" {
  type = "map"
  default = {
    "us-east-1" = "ami-6d1c2007"
    "us-east-2" = "ami-6a2d760f"
  }
}

variable "server_port" {
  description = "The port the server will use for HTTP requests"
  default = "80"
}
