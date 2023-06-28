resource "aws_apigatewayv2_api" "main" {
  name          = "main"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_stage" "staging" {
  name        = var.DEFAULT_API_GW_STAGE
  api_id      = aws_apigatewayv2_api.main.id
  auto_deploy = true
}

resource "aws_apigatewayv2_domain_name" "api" {
  domain_name = local.api_gw_fqdn

  domain_name_configuration {
    certificate_arn = aws_acm_certificate.api.arn
    endpoint_type   = "REGIONAL"
    security_policy = "TLS_1_2"
  }

  depends_on = [aws_acm_certificate_validation.api]
}

resource "aws_apigatewayv2_api_mapping" "api" {
  api_id      = aws_apigatewayv2_api.main.id
  domain_name = aws_apigatewayv2_domain_name.api.id
  stage       = aws_apigatewayv2_stage.staging.id
}
