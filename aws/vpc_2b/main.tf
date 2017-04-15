data "aws_availability_zones" "all" {}

data "template_file" "apache_bootstrap" {
  template = "${file("scripts/apache.sh")}"
  vars {
    server_port = "${var.server_port}"
    region = "${var.aws_region}"
  }
}
