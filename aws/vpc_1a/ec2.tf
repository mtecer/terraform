data "template_file" "apache_bootstrap" {
  template = "${file("scripts/apache.sh")}"
  vars {
    server_port = "${var.server_port}"
    region = "${var.aws_region}"
  }
}

resource "aws_vpc" "vpc" {
  cidr_block = "${var.vpc_cidr}"
  enable_dns_support = true
  enable_dns_hostnames = true

  tags {
    Name = "vpc"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id = "${aws_vpc.vpc.id}"
  cidr_block = "${var.public_cidr}"
  map_public_ip_on_launch = true
  availability_zone = "${var.aws_az}"

  tags {
  	Name =  "public_subnet"
  }
}

resource "aws_internet_gateway" "vpc_gw" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags {
        Name = "vpc_gw"
    }
}

resource "aws_route" "internet_access" {
  route_table_id = "${aws_vpc.vpc.main_route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = "${aws_internet_gateway.vpc_gw.id}"
}

resource "aws_security_group" "allow_ssh_web" {
  name = "allow_ssh_web"
  description = "Allow ingress SSH, HTTP and HTTPS traffic"
  vpc_id = "${aws_vpc.vpc.id}"

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

resource "aws_instance" "web" {
  count = "${var.count}"
  ami = "${lookup(var.aws_amis, var.aws_region)}"
  instance_type = "${var.instance_type}"
  key_name = "${var.aws_key_name}"
  subnet_id = "${aws_subnet.public_subnet.id}"
  vpc_security_group_ids = [
    "${aws_security_group.allow_ssh_web.id}",
  ]
  user_data = "${data.template_file.apache_bootstrap.rendered}"

  tags {
    Name = "${var.instance_name}-${count.index}"
  }
}

output "private_ip_web" {
  value = "${join(",", aws_instance.web.*.private_ip)}"
}

output "public_ip_web" {
  value = "${join(",", aws_instance.web.*.public_ip)}"
}
