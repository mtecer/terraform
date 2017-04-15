# Terraform configuration for AWS VPC

- VPC
- public and multiple private subnets
- NAT gateway
- Instances: Bastion, Web, DB




- Security Groups in Loops
- If conditionals
- Multiple firewalls specific to bastion
    - sg for bastion, ssh and ping
    - sg for web,
    - sg for db,
    
    
- vpc
- bastion
- asg for web


- format_list : https://terraform.io/docs/configuration/interpolation.html#formatlist_format_args_
- element examples
- READ: http://docs.aws.amazon.com/AmazonVPC/latest/UserGuide/VPC_Scenario2.html


resource "aws_security_group" "foo" {
  count = "${var.instances}"
  ingress {
    from_port = 80
    to_port = 80
    protocol = "http"
    cidr_blocks = ["${element(aws_instance.bar.*.public_ip, count.index)}/32"]
  }
}

- Add tags "Terraform: true"

- Ssh agent forwarding must be allowed on the client (ForwardAgent option in ~/.ssh/config) and on the server 
(AllowAgentForwarding option in sshd_config). Chances are that your machines have different default settings 
for one or both of these options.




variable "subnets" {
  default = {
    "0" = "subnet-123"
    "1" = "subnet-456"
    "2" = "subnet-789"
  }
}

resource "aws_instance" "web-layer" {
  connection {
    user = "ec2-user"
    key_file = "${var.aws_key_path}"
  }
  count = 6
  ami = "${var.aws_ami}"
  instance_type = "${var.aws_instance}"
  subnet_id = "${lookup(var.subnets, count.index)}"  
  subnet_id = "${lookup(var.subnets, count.index%3)}"
  tags {
    Name = "web-layer-${var.environment}-${count.index}"
    Environment = "${var.environment}"
  }
  # Set user data
  user_data = "${file(\"bootstrap.sh\")}"
  key_name = "${var.aws_key_name}"
}




variable "security-ports" {
  description = "inbound sg"
  default  = "80,22,443"
  }
}


resource "aws_security_group_rule" "rule" {
  count = "${count(split(",",var.security-ports))}"
  type = "ingress"
  from_port = "${element(split(",", var.security-ports), count.index)}"
  to_port = "${element(split(",", var.security-ports), count.index)}"
  protocol = "TCP"
  cidr_blocks = ["${var.cidr_blocks}"]

  security_group_id = "${aws_security_group.default.id}"
 }
 
 
 
 
${length(split(",", "a,b,c"))} = 3
${length("a,b,c")} = 5
${length(map("key", "val"))} = 1

 
 
 
provider "aws" {
  region = "us-east-1"
}

data "aws_availability_zones" "available" {}

resource "aws_launch_configuration" "web" {
  name = "web"
  image_id = "ami-408c7f28"
  instance_type = "t2.micro"
}

resource "aws_autoscaling_group" "web" {
  launch_configuration = "${aws_launch_configuration.web.name}"
  desired_capacity = "${length(aws_autoscaling_group.available.names)}"
  availability_zones = ["${aws_autoscaling_group.available.names}"]
  # ... and any other settings you need ...
}




 
 
 variable "region" {}
variable "account" {}

output "primary" {
    value = "${lookup(var.primary_azs, format(\"%s-%s\", var.account, var.region))}"
}
output "secondary" {
    value = "${lookup(var.secondary_azs, format(\"%s-%s\", var.account, var.region))}"
}
output "tertiary" {
    value = "${lookup(var.tertiary_azs, format(\"%s-%s\", var.account, var.region))}"
}
output "list_all" {
    value = "${lookup(var.list_all, format(\"%s-%s\", var.account, var.region))}"
}
output "az_count" {
    value = "${lookup(var.az_counts, format(\"%s-%s\", var.account, var.region))}"
}
output "list_letters" {
    value = "${lookup(var.list_letters, format(\"%s-%s\", var.account, var.region))}"
}




    cidr_blocks = ["${split(",", var.allowed_cidr_blocks)}"]





variable "zones" {
    default = {
        zone0 = "us-west-2a"
        zone1 = "us-west-2b"
        zone2 = "us-west-2c"
    }
}

variable "cidr_blocks" {
    default = {
        zone0 = "172.64.0.0/22"
        zone1 = "172.64.0.4/22"
        zone2 = "172.64.0.8/22"
    }
}

resource "aws_subnet" "coreospub" {
  vpc_id = "${aws_vpc.coreos.id}"
  cidr_block = "${lookup(var.cidr_blocks, concat("zone", count.index))}"
  availability_zone = "${lookup(var.zones, concat("zone", count.index))}"
  map_public_ip_on_launch = true
  count = 3
}

resource "aws_instance" "coreos" {
  ami = "${lookup(var.aws_amis, var.aws_region)}"
  instance_type = "${var.aws_instance_type}"
  count = 3
  key_name = "${var.aws_key_name}"
  security_groups = ["${aws_security_group.ssh.id}", "${aws_security_group.self.id}"]
  subnet_id = "${element(aws_subnet.coreospub.*.id, count.index)}"
}



lookup(var.vpc_availability_zone, "zone_${count.index}")
Or, in my case:
lookup(var.vpc_availability_zone, "zone_${count.index % 3}")













#!/bin/bash -v

CHEF_VERSION=${chef_version}

NODE_NAME="#ROLE-$${EC2_INSTANCE_ID}"

cat >> /etc/chef/client.rb <<EOF
node_name "$${NODE_NAME}"
EOF

/usr/bin/chef-client -r "role[${role}]" -E ${environment}


resource "template_file" "userdata_packer" {
  filename = "userdata_packer.tpl"
  vars {   
    chef_version = "${var.chef_version}"
    chef_host = "${var.chef_host}"
  }
  ignore_unknown_vars = true
}


resource "aws_launch_configuration" "fortytwo-default" {
  # ...
  user_data = "${template(template_file.userdata_packer.rendered, "role=default", "environment=fortytwo")}" 
  # ...
}






general-init.conf
#cloud-config

hostname: ${hostname}


resource "template_file" "client-config" {
  template = "${file("files/general-init.conf")}"
  count = "${var.client-count}"

  vars {
    index = "${count.index}"
    hostname = "client-${count.index}"
  }
}



resource "aws_instance" "client" {
  ...
  user_data = "${element(template_file.client-config.*.rendered, count.index)}"

  count = 2
  ...
}







