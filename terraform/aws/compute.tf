###########################################
################ Key Pair #################
###########################################

variable "key_name" {

  default = "ccloud-tools"

}
resource "tls_private_key" "key_pair" {

  algorithm = "RSA"
  rsa_bits  = 4096

}
resource "aws_key_pair" "generated_key" {

  key_name   = "${var.key_name}"
  public_key = "${tls_private_key.key_pair.public_key_openssh}"

}

###########################################
############ Schema Registry ##############
###########################################

resource "aws_instance" "schema_registry" {

  depends_on = ["aws_subnet.private_subnet_1",
                "aws_subnet.private_subnet_2"]

  count = "${var.instance_count["schema_registry"]}"
  ami = "ami-0922553b7b0369273"
  instance_type = "t3.medium"
  key_name = "${aws_key_pair.generated_key.key_name}"

  subnet_id = "${element(data.aws_subnet_ids.private.ids, count.index)}"
  vpc_security_group_ids = ["${aws_security_group.schema_registry.id}"]

  user_data = "${data.template_file.schema_registry_bootstrap.rendered}"

  ebs_block_device {

    device_name = "/dev/xvdb"
    volume_type = "gp2"
    volume_size = 10

  }

  tags {

    Name = "schema-registry"

  }

}

###########################################
############## REST Proxy #################
###########################################

resource "aws_instance" "rest_proxy" {

  depends_on = ["aws_instance.schema_registry"]

  count = "${var.instance_count["rest_proxy"]}"
  ami = "ami-0922553b7b0369273"
  instance_type = "t3.medium"
  key_name = "${aws_key_pair.generated_key.key_name}"

  subnet_id = "${element(data.aws_subnet_ids.private.ids, count.index)}"
  vpc_security_group_ids = ["${aws_security_group.rest_proxy.id}"]
  
  user_data = "${data.template_file.rest_proxy_bootstrap.rendered}"

  ebs_block_device {

    device_name = "/dev/xvdb"
    volume_type = "gp2"
    volume_size = 10

  }

  tags {

    Name = "rest-proxy"

  }

}

###########################################
############ Control Center ###############
###########################################

resource "aws_instance" "control_center" {

  depends_on = ["aws_instance.schema_registry"]

  count = "${var.instance_count["control_center"]}"
  ami = "ami-0922553b7b0369273"
  instance_type = "t3.2xlarge"
  key_name = "${aws_key_pair.generated_key.key_name}"

  subnet_id = "${element(data.aws_subnet_ids.private.ids, count.index)}"
  vpc_security_group_ids = ["${aws_security_group.control_center.id}"]
  
  user_data = "${data.template_file.control_center_bootstrap.rendered}"

  ebs_block_device {

    device_name = "/dev/xvdb"
    volume_type = "gp2"
    volume_size = 300

  }

  tags {

    Name = "control-center"

  }

}

###########################################
############# REST Proxy LBR ##############
###########################################

resource "aws_alb_target_group" "rest_proxy_target_group" {

  name = "rest-proxy-target-group"  
  port = "8082"
  protocol = "HTTP"
  vpc_id   = "${aws_vpc.default.id}"

  health_check {    

    healthy_threshold = 3    
    unhealthy_threshold = 3    
    timeout = 3   
    interval = 5    
    path = "/"
    port = "8082"

  }

}

resource "aws_alb_target_group_attachment" "rest_proxy_attachment" {

  count = "${var.instance_count["rest_proxy"]}"

  target_group_arn = "${aws_alb_target_group.rest_proxy_target_group.arn}"
  target_id = "${element(aws_instance.rest_proxy.*.id, count.index)}"
  port = 8082

}

resource "aws_alb" "rest_proxy" {

  depends_on = ["aws_instance.rest_proxy"]

  name = "rest-proxy"
  subnets = ["${aws_subnet.public_subnet_1.id}", "${aws_subnet.public_subnet_2.id}"]
  security_groups = ["${aws_security_group.load_balancer.id}"]
  internal = false

  tags {

    Name = "rest-proxy"

  }

}

resource "aws_alb_listener" "rest_proxy_listener" {

  load_balancer_arn = "${aws_alb.rest_proxy.arn}"  
  protocol          = "HTTP"
  port              = "80"
  
  default_action {

    target_group_arn = "${aws_alb_target_group.rest_proxy_target_group.arn}"
    type             = "forward"

  }

}

###########################################
########### Control Center LBR ############
###########################################

resource "aws_alb_target_group" "control_center_target_group" {

  name = "control-center-target-group"  
  port = "9021"
  protocol = "HTTP"
  vpc_id   = "${aws_vpc.default.id}"

  health_check {    

    healthy_threshold = 3    
    unhealthy_threshold = 3    
    timeout = 3   
    interval = 5    
    path = "/"
    port = "9021"

  }

}

resource "aws_alb_target_group_attachment" "control_center_attachment" {

  count = "${var.instance_count["control_center"]}"

  target_group_arn = "${aws_alb_target_group.control_center_target_group.arn}"
  target_id = "${element(aws_instance.control_center.*.id, count.index)}"
  port = 9021

}

resource "aws_alb" "control_center" {

  depends_on = ["aws_instance.control_center"]

  name = "control-center"
  subnets = ["${aws_subnet.public_subnet_1.id}", "${aws_subnet.public_subnet_2.id}"]
  security_groups = ["${aws_security_group.load_balancer.id}"]
  internal = false

  tags {

    Name = "control-center"

  }

}

resource "aws_alb_listener" "control_center_listener" {

  load_balancer_arn = "${aws_alb.control_center.arn}"  
  protocol          = "HTTP"
  port              = "80"
  
  default_action {

    target_group_arn = "${aws_alb_target_group.control_center_target_group.arn}"
    type             = "forward"

  }

}