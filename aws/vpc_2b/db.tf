resource "aws_instance" "db" {
  count = "${var.count}"
  ami = "${lookup(var.aws_amis, var.aws_region)}"
  instance_type = "${var.instance_type}"
  key_name = "${var.aws_key_name}"
  subnet_id = "${aws_subnet.private_subnet.id}"
  vpc_security_group_ids = [
    "${aws_security_group.allow_egress.id}"
    "${aws_security_group.allow_mysql_from_web.id}",
  ]

  user_data = "${data.template_file.apache_bootstrap.rendered}"

  root_block_device {
    volume_type = "standard"
    volume_size = "${var.root_volume_size}"
    delete_on_termination = "${var.volume_delete_on_termination}"
  }

  tags {
    Name = "${var.instance_name}-db-${count.index}"
  }
}