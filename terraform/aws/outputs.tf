###########################################
################# Outputs #################
###########################################

output "schema_registry_endpoint" {

  value = "http://${aws_alb.schema_registry.dns_name}"

}

output "rest_proxy_endpoint" {

  value = "http://${aws_alb.rest_proxy.dns_name}"

}

output "kafka_connect_endpoint" {

  value = "http://${aws_alb.kafka_connect.dns_name}"

}

output "ksql_server_endpoint" {

  value = "http://${aws_alb.ksql_server.dns_name}"

}

output "control_center_endpoint" {

  value = "http://${aws_alb.control_center.dns_name}"

}