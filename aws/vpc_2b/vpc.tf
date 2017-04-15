resource "aws_vpc" "vpc" {
  cidr_block = "${var.vpc_cidr}"
  enable_dns_support = true
  enable_dns_hostnames = true

  tags {
    Name = "vpc"
    Terraform = true
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id = "${aws_vpc.vpc.id}"
  cidr_block = "${var.public_cidr}"
  map_public_ip_on_launch = true
  availability_zone = "${var.aws_az}"

  tags {
  	Name =  "public_subnet"
    Terraform = true
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id = "${aws_vpc.vpc.id}"
  cidr_block = "${var.private_cidr}"
  availability_zone = "${var.aws_az}"

  tags {
  	Name =  "private_subnet"
    Terraform = true
  }
}

resource "aws_internet_gateway" "vpc_gw" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags {
    Name = "vpc_gw"
    Terraform = true
  }
}

resource "aws_route" "internet_access" {
  route_table_id = "${aws_vpc.vpc.main_route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = "${aws_internet_gateway.vpc_gw.id}"
}

resource "aws_eip" "vpc_nat_eip" {
  vpc = true
  depends_on = ["aws_internet_gateway.vpc_gw"]
}

resource "aws_nat_gateway" "vpc_nat" {
  allocation_id = "${aws_eip.vpc_nat_eip.id}"
  subnet_id = "${aws_subnet.public_subnet.id}"
  depends_on = ["aws_internet_gateway.vpc_gw"]
}

resource "aws_route_table" "private_route_table" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags {
    Name = "Private route table"
    Terraform = true
  }
}

resource "aws_route" "private_route" {
  route_table_id  = "${aws_route_table.private_route_table.id}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = "${aws_nat_gateway.vpc_nat.id}"
}

# Associate public_subnet to public route table
resource "aws_route_table_association" "public_subnet_association" {
  subnet_id = "${aws_subnet.public_subnet.id}"
  route_table_id = "${aws_vpc.vpc.main_route_table_id}"
}

# Associate private_subnet to private route table
resource "aws_route_table_association" "private_subnet_association" {
  subnet_id = "${aws_subnet.private_subnet.id}"
  route_table_id = "${aws_route_table.private_route_table.id}"
}

resource "aws_security_group" "allow_egress" {
  name = "allow_ssh"
  description = "Allow ingress SSH traffic"
  vpc_id = "${aws_vpc.vpc.id}"

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "Allow access to internet"
    Terraform = true
  }
}

resource "aws_security_group" "allow_ssh" {
  name = "allow_ssh"
  description = "Allow ingress SSH traffic"
  vpc_id = "${aws_vpc.vpc.id}"

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "Allow ssh from all"
    Terraform = true
  }
}

resource "aws_security_group" "allow_web" {
  name = "allow_web"
  description = "Allow ingress HTTP and HTTPS traffic"
  vpc_id = "${aws_vpc.vpc.id}"

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

  tags {
    Name = "Allow web from all"
    Terraform = true
  }
}

resource "aws_security_group" "allow_ssh_from_bastion" {
  name = "allow_ssh_from_bastion"
  description = "Allow ingress SSH traffic from bastion instance"
  vpc_id = "${aws_vpc.vpc.id}"

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["${aws_instance.bastion.*.private_ip}}"]
  }

  tags {
    Name = "Allow ssh from bastion"
    Terraform = true
  }
}

resource "aws_security_group" "allow_mysql_from_web" {
  name = "allow_mysql_from_bastion"
  description = "Allow ingress MySQL traffic from bastion instance"
  vpc_id = "${aws_vpc.vpc.id}"

  ingress {
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
    cidr_blocks = ["${aws_autoscaling_group.web.*. .web.*.private_ip}}"]
  }

  tags {
    Name = "Allow mysql from all"
    Terraform = true
  }
}

