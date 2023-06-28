resource "aws_apigatewayv2_integration" "httpbin_integration" {
  api_id           = aws_apigatewayv2_api.main.id
  integration_type = "HTTP_PROXY"

  integration_method = "ANY"
  integration_uri    = "https://httpbin.org/anything/{proxy}"
}

resource "aws_apigatewayv2_route" "httpbin_route" {
  api_id    = aws_apigatewayv2_api.main.id
  route_key = "ANY /httpbin_integration/{proxy+}"

  target = "integrations/${aws_apigatewayv2_integration.httpbin_integration.id}"
}
