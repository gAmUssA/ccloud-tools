###########################################
################# Outputs #################
###########################################

output "schema_registry_endpoint" {

  value = "http://${aws_alb.schema_registry.dns_name}"

}

output "rest_proxy_endpoint" {

  value = "http://${aws_alb.rest_proxy.dns_name}"

}

output "control_center_endpoint" {

  value = "http://${aws_alb.control_center.dns_name}"

}