resource "aws_launch_configuration" "web_lc" {
  name_prefix         = "web"
  image_id            = "${lookup(var.aws_amis, var.aws_region)}"
  instance_type       = "${var.instance_type}"
  key_name            = "${var.aws_key_name}"
  vpc_zone_identifier = ["${aws_subnet.public_subnet.id}"]
  security_groups     = [
    "${aws_security_group.allow_egress.id}",
    "${aws_security_group.allow_web.id}"
  ]
  user_data           = "${data.template_file.apache_bootstrap.rendered}"

  root_block_device {
    volume_type           = "standard"
    volume_size           = "${var.root_volume_size}"
    delete_on_termination = "${var.volume_delete_on_termination}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "web_asg" {
  launch_configuration = "${aws_launch_configuration.web.id}"

  availability_zones    = ["${data.aws_availability_zones.all.names}"]
  availability_zones    = ["${split(",", var.availability_zones)}"]


  variable "availability_zones" {
  default     = "us-east-1b,us-east-1c,us-east-1d,us-east-1e"
  description = "List of availability zones, use AWS CLI to find your "
}

  min_size              = 2
  max_size              = 4

  desired_capacity      = "${var.asg_desired}"

  force_delete          = true

  load_balancers        = ["${aws_elb.web-elb.name}"]


  tag {
    key                 = "Name"
    value               = "${var.instance_name}-web-${count.index}"
    propagate_at_launch = true
  }
}

resource "aws_elb" "web_elb" {
  name = "terraform-example-elb"

  # The same availability zone as our instances
  availability_zones    = ["${split(",", var.availability_zones)}"]

  listener {
    instance_port       = 80
    instance_protocol   = "http"
    lb_port             = 80
    lb_protocol         = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/"
    interval            = 60
  }
}
