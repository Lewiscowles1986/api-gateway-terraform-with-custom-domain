resource "aws_api_gateway_resource" "httpbin_root_resource" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  parent_id   = aws_api_gateway_rest_api.main.root_resource_id
  path_part   = "httpbin_integration"
}

resource "aws_api_gateway_resource" "httpbin_resource" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  parent_id   = aws_api_gateway_resource.httpbin_root_resource.id
  path_part   = "{proxy+}"
}

resource "aws_api_gateway_method" "httpbin_method_binding" {
  rest_api_id   = aws_api_gateway_rest_api.main.id
  resource_id   = aws_api_gateway_resource.httpbin_resource.id
  http_method   = "ANY"
  authorization = "NONE"
   request_parameters = {
    "method.request.path.proxy" = true
  }
}

resource "aws_api_gateway_integration" "httpbin_integration" {
  rest_api_id          = aws_api_gateway_rest_api.main.id
  resource_id          = aws_api_gateway_resource.httpbin_resource.id
  http_method          = aws_api_gateway_method.httpbin_method_binding.http_method
  type                 = "HTTP_PROXY"
  uri                  = "https://httpbin.org/anything/{proxy}"
  integration_http_method = aws_api_gateway_method.httpbin_method_binding.http_method

  cache_key_parameters = ["method.request.path.proxy"]

  timeout_milliseconds = 29000
  request_parameters = {
    "integration.request.path.proxy" = "method.request.path.proxy"
  }

}

resource "aws_api_gateway_deployment" "teststage" {
  depends_on = [
    aws_api_gateway_resource.httpbin_resource,
    aws_api_gateway_method.httpbin_method_binding,
    aws_api_gateway_integration.httpbin_integration
  ]
  rest_api_id = aws_api_gateway_rest_api.main.id
  
  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.httpbin_resource,
      aws_api_gateway_method.httpbin_method_binding,
      aws_api_gateway_integration.httpbin_integration,
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }
}
