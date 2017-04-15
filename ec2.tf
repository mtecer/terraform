//provider "aws" {
//  //  access_key = ""
//  //  secret_key = ""
//  region = "${var.aws_region}"
//}

//data "template_file" "apache_bootstrap" {
//  template = "${file("scripts/apache.sh")}"
//  vars {
//    server_port = "${var.server_port}"
//    region = "${var.aws_region}"
//  }
//}
//
//resource "aws_vpc" "mtecer_vpc" {
//  cidr_block = "10.10.0.0/16"
//  enable_dns_support = true
//  enable_dns_hostnames = true
//
//  tags {
//    Name = "mtecer_vpc"
//  }
//}

//resource "aws_subnet" "mtecer_public_subnet" {
//  vpc_id = "${aws_vpc.mtecer_vpc.id}"
//  cidr_block = "10.10.1.0/24"
//  map_public_ip_on_launch = true
//  availability_zone = "${var.aws_az}"
//
//  tags = {
//  	Name =  "mtecer_public_subnet"
//  }
//}
//
//resource "aws_subnet" "mtecer_private_subnet_1" {
//  vpc_id = "${aws_vpc.mtecer_vpc.id}"
//  cidr_block = "10.10.2.0/24"
//  availability_zone = "${var.aws_az}"
//
//  tags = {
//  	Name =  "mtecer_private_subnet_1"
//  }
//}
//
//resource "aws_subnet" "mtecer_private_subnet_2" {
//  vpc_id = "${aws_vpc.mtecer_vpc.id}"
//  cidr_block = "10.10.3.0/24"
//  availability_zone = "${var.aws_az}"
//
//  tags = {
//  	Name =  "mtecer_private_subnet_2"
//  }
//}

//resource "aws_internet_gateway" "mtecer_vpc_gw" {
//  vpc_id = "${aws_vpc.mtecer_vpc.id}"
//
//  tags {
//        Name = "mtecer_vpc_gw"
//    }
//}
//
//resource "aws_route" "internet_access" {
//  route_table_id = "${aws_vpc.mtecer_vpc.main_route_table_id}"
//  destination_cidr_block = "0.0.0.0/0"
//  gateway_id = "${aws_internet_gateway.mtecer_vpc_gw.id}"
//}

resource "aws_eip" "mtecer_vpc_nat_eip" {
  vpc = true
  depends_on = ["aws_internet_gateway.mtecer_vpc_gw"]
}

resource "aws_nat_gateway" "mtecer_vpc_nat" {
    allocation_id = "${aws_eip.mtecer_vpc_nat_eip.id}"
    subnet_id = "${aws_subnet.mtecer_public_subnet.id}"
    depends_on = ["aws_internet_gateway.mtecer_vpc_gw"]
}

resource "aws_route_table" "mtecer_private_route_table" {
    vpc_id = "${aws_vpc.mtecer_vpc.id}"

    tags {
        Name = "Private route table"
    }
}

resource "aws_route" "private_route" {
	route_table_id  = "${aws_route_table.mtecer_private_route_table.id}"
	destination_cidr_block = "0.0.0.0/0"
	nat_gateway_id = "${aws_nat_gateway.mtecer_vpc_nat.id}"
}

# Associate subnet public_subnet to public route table
resource "aws_route_table_association" "public_subnet_association" {
    subnet_id = "${aws_subnet.mtecer_public_subnet.id}"
    route_table_id = "${aws_vpc.mtecer_vpc.main_route_table_id}"
}

# Associate subnet private_subnet_1 to private route table
resource "aws_route_table_association" "private_subnet_1_association" {
    subnet_id = "${aws_subnet.mtecer_private_subnet_1.id}"
    route_table_id = "${aws_route_table.mtecer_private_route_table.id}"
}

# Associate subnet private_subnet_2 to private route table
resource "aws_route_table_association" "private_subnet_2_association" {
    subnet_id = "${aws_subnet.mtecer_private_subnet_2.id}"
    route_table_id = "${aws_route_table.mtecer_private_route_table.id}"
}

resource "aws_instance" "public_bastion_1" {
  ami = "${lookup(var.aws_amis, var.aws_region)}"
  instance_type = "${var.instance_type}"
  key_name = "${var.aws_key_name}"
//  subnet_id = "${var.subnet_id}"
  subnet_id = "${aws_subnet.mtecer_private_subnet_1.id}"
  vpc_security_group_ids = [
    "${aws_security_group.mtecer_allow_ssh_web.id}",
  ]
  user_data = "${data.template_file.apache_bootstrap.rendered}"

  tags {
    Name = "${var.instance_name}"
  }
}

resource "aws_instance" "private_web_1" {
  ami = "${lookup(var.aws_amis, var.aws_region)}"
  instance_type = "${var.instance_type}"
  key_name = "${var.aws_key_name}"
//  subnet_id = "${var.subnet_id}"
  subnet_id = "${aws_subnet.mtecer_private_subnet_1.id}"
  vpc_security_group_ids = [
    "${aws_security_group.mtecer_allow_ssh_web.id}",
  ]
  user_data = "${data.template_file.apache_bootstrap.rendered}"

  tags {
    Name = "${var.instance_name}"
  }
}

resource "aws_instance" "private_web_2" {
  ami = "${lookup(var.aws_amis, var.aws_region)}"
  instance_type = "${var.instance_type}"
  key_name = "${var.aws_key_name}"
  subnet_id = "${aws_subnet.mtecer_private_subnet_1.id}"
  vpc_security_group_ids = [
    "${aws_security_group.mtecer_allow_ssh_web.id}",
  ]
  user_data = "${data.template_file.apache_bootstrap.rendered}"

  tags {
    Name = "${var.instance_name}"
  }
}

resource "aws_security_group" "mtecer_allow_ssh_web" {
  name = "mtecer_allow_ssh_web"
  description = "Allow ingress SSH, HTTP and HTTPS traffic"
  vpc_id = "${aws_vpc.mtecer_vpc.id}"

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

   egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "Allow inbound SSH and WEB"
  }
}

output "public_ip_private_web_1" {
  value = "${join(",", aws_instance.private_web_1.*.public_ip)}"
}

output "public_ip_private_web_2" {
  value = "${join(",", aws_instance.private_web_2.*.public_ip)}"
}
