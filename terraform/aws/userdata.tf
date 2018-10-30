###########################################
####### Schema Registry Bootstrap #########
###########################################

data "template_file" "schema_registry_properties" {

  template = "${file("bootstrap/schema-registry.properties")}"

  vars {

    bootstrap_servers = "${var.ccloud_bootstrap_servers}"
    access_key = "${var.ccloud_access_key}"
    secret_key = "${var.ccloud_secret_key}"

  }

}

data "template_file" "schema_registry_bootstrap" {

  template = "${file("bootstrap/schema-registry.sh")}"

  vars {

    confluent_platform_location = "${var.confluent_platform_location}"
    schema_registry_properties = "${data.template_file.schema_registry_properties.rendered}"

  }

}

###########################################
######### REST Proxy Bootstrap ############
###########################################

data "template_file" "rest_proxy_properties" {

  template = "${file("bootstrap/rest-proxy.properties")}"

  vars {

    bootstrap_servers = "${var.ccloud_bootstrap_servers}"
    access_key = "${var.ccloud_access_key}"
    secret_key = "${var.ccloud_secret_key}"

    schema_registry_url = "${join(",", formatlist("http://%s:%s",
      aws_instance.schema_registry.*.private_ip, "8081"))}"

  }

}

data "template_file" "rest_proxy_bootstrap" {

  template = "${file("bootstrap/rest-proxy.sh")}"

  vars {

    confluent_platform_location = "${var.confluent_platform_location}"
    rest_proxy_properties = "${data.template_file.rest_proxy_properties.rendered}"

  }

}

###########################################
######## Control Center Bootstrap #########
###########################################

data "template_file" "ksql_server_properties" {

  template = "${file("bootstrap/ksql-server.properties")}"

  vars {

    bootstrap_servers = "${var.ccloud_bootstrap_servers}"
    access_key = "${var.ccloud_access_key}"
    secret_key = "${var.ccloud_secret_key}"

    schema_registry_url = "${join(",", formatlist("http://%s:%s",
      aws_instance.schema_registry.*.private_ip, "8081"))}"

  }

}

data "template_file" "control_center_properties" {

  template = "${file("bootstrap/control-center.properties")}"

  vars {

    bootstrap_servers = "${var.ccloud_bootstrap_servers}"
    access_key = "${var.ccloud_access_key}"
    secret_key = "${var.ccloud_secret_key}"

    schema_registry_url = "${join(",", formatlist("http://%s:%s",
      aws_instance.schema_registry.*.private_ip, "8081"))}"

  }

}

data "template_file" "control_center_bootstrap" {

  template = "${file("bootstrap/control-center.sh")}"

  vars {

    confluent_platform_location = "${var.confluent_platform_location}"
    ksql_server_properties = "${data.template_file.ksql_server_properties.rendered}"
    control_center_properties = "${data.template_file.control_center_properties.rendered}"

  }

}