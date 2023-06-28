output "custom_domain_api" {
  value = "https://${aws_api_gateway_domain_name.api.domain_name}"
}
