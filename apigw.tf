resource "aws_api_gateway_rest_api" "main" {
  name = "main"
}

resource "aws_api_gateway_domain_name" "api" {
  domain_name = local.api_gw_fqdn
  regional_certificate_arn = aws_acm_certificate.api.arn
  security_policy = "TLS_1_2"

  endpoint_configuration {
    types           = ["REGIONAL"]
  }

  depends_on = [aws_acm_certificate_validation.api]
}

resource "aws_api_gateway_stage" "staging" {
  depends_on    = [aws_api_gateway_domain_name.api]
  stage_name    = var.DEFAULT_API_GW_STAGE
  rest_api_id   = aws_api_gateway_rest_api.main.id
  deployment_id = aws_api_gateway_deployment.teststage.id
}

resource "aws_api_gateway_base_path_mapping" "example" {
  api_id      = aws_api_gateway_rest_api.main.id
  stage_name  = aws_api_gateway_stage.staging.stage_name
  domain_name = aws_api_gateway_domain_name.api.domain_name
}