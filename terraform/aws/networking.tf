###########################################
################### VPC ###################
###########################################
resource "aws_vpc" "default" {
    
    cidr_block = "10.0.0.0/16"

    tags {

        Name = "ccloud-tools"

    }

}

resource "aws_internet_gateway" "default" {

  vpc_id = "${aws_vpc.default.id}"

    tags {

        Name = "ccloud-tools"

    }

}

resource "aws_route" "default" {

  route_table_id         = "${aws_vpc.default.main_route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.default.id}"

}

###########################################
################# Subnets #################
###########################################

data "aws_subnet_ids" "private" {

  vpc_id = "${aws_vpc.default.id}"

  filter {

    name = "tag:Name"
    values = ["private-subnet"]

  }

}

resource "aws_subnet" "private_subnet_1" {

  vpc_id = "${aws_vpc.default.id}"
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone = "${element(var.aws_availability_zones, 0)}"

    tags {

        Name = "private-subnet"

    }    

}

resource "aws_subnet" "private_subnet_2" {

  vpc_id = "${aws_vpc.default.id}"
  cidr_block = "10.0.2.0/24"
  map_public_ip_on_launch = true
  availability_zone = "${element(var.aws_availability_zones, 1)}"

    tags {

        Name = "private-subnet"

    }    

}

resource "aws_subnet" "private_subnet_3" {

  vpc_id = "${aws_vpc.default.id}"
  cidr_block = "10.0.3.0/24"
  map_public_ip_on_launch = true
  availability_zone = "${element(var.aws_availability_zones, 2)}"

    tags {

        Name = "private-subnet"

    }    

}

resource "aws_subnet" "public_subnet_1" {

  vpc_id                  = "${aws_vpc.default.id}"
  cidr_block              = "10.0.4.0/24"
  map_public_ip_on_launch = true
  availability_zone = "${element(var.aws_availability_zones, 0)}"

    tags {

        Name = "public-subnet"

    }    

}

resource "aws_subnet" "public_subnet_2" {

  vpc_id                  = "${aws_vpc.default.id}"
  cidr_block              = "10.0.5.0/24"
  map_public_ip_on_launch = true
  availability_zone = "${element(var.aws_availability_zones, 1)}"

    tags {

        Name = "public-subnet"

    }    

}

###########################################
############# Security Groups #############
###########################################

resource "aws_security_group" "load_balancer" {

  name        = "load-balancer"
  description = "Load Balancer"
  vpc_id      = "${aws_vpc.default.id}"

  ingress {

    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  egress {

    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    
  }  
  
}

resource "aws_security_group" "schema_registry" {

  name        = "schema-registry"
  description = "Schema Registry"
  vpc_id      = "${aws_vpc.default.id}"

  ingress {

    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.4.0/24", "10.0.5.0/24"]

  }

  ingress {

    from_port   = 8081
    to_port     = 8081
    protocol    = "tcp"
    cidr_blocks = ["10.0.4.0/24", "10.0.5.0/24"]

  }

  egress {

    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    
  }  
  
}

resource "aws_security_group" "rest_proxy" {

  name        = "rest-proxy"
  description = "REST Proxy"
  vpc_id      = "${aws_vpc.default.id}"

  ingress {

    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.4.0/24", "10.0.5.0/24"]

  }

  ingress {

    from_port   = 8082
    to_port     = 8082
    protocol    = "tcp"
    cidr_blocks = ["10.0.4.0/24", "10.0.5.0/24"]

  }

  egress {

    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    
  }  
  
}

resource "aws_security_group" "control_center" {

  name        = "control-center"
  description = "Control Center"
  vpc_id      = "${aws_vpc.default.id}"

  ingress {

    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.4.0/24", "10.0.5.0/24"]

  }

  ingress {

    from_port   = 9021
    to_port     = 9021
    protocol    = "tcp"
    cidr_blocks = ["10.0.4.0/24", "10.0.5.0/24"]

  }

  egress {

    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    
  }  
  
}