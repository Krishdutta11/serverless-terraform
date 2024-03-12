# Create API gateway
resource "aws_api_gateway_rest_api" "apigw" {
  name = "POC-API"
}

# Cretae method
resource "aws_api_gateway_method" "apigw_method" {
  authorization = "NONE"
  http_method   = "POST"
  resource_id   = aws_api_gateway_rest_api.apigw.root_resource_id
  rest_api_id   = aws_api_gateway_rest_api.apigw.id
}

# Create request integration
resource "aws_api_gateway_integration" "apigw_integration" {
  integration_http_method = "POST"
  http_method             = aws_api_gateway_method.apigw_method.http_method
  resource_id             = aws_api_gateway_rest_api.apigw.root_resource_id
  rest_api_id             = aws_api_gateway_rest_api.apigw.id
  type                    = "AWS"
  credentials             = aws_iam_role.api.arn
  uri                     = "arn:aws:apigateway:us-east-1:sqs:path/${aws_sqs_queue.standard_queue.name}"

  request_parameters = {
    "integration.request.header.Content-Type" = "'application/x-www-form-urlencoded'"
  }

  request_templates = {
    "application/json" = "Action=SendMessage&MessageBody=$input.body"
  }
}

# Construct method response
resource "aws_api_gateway_method_response" "success_response" {
  rest_api_id = aws_api_gateway_rest_api.apigw.id
  resource_id = aws_api_gateway_rest_api.apigw.root_resource_id
  http_method = aws_api_gateway_method.apigw_method.http_method
  status_code = 200

  response_models = {
    "application/json" = "Empty"
  }
}

# construct integration response
resource "aws_api_gateway_integration_response" "success_response" {
  rest_api_id       = aws_api_gateway_rest_api.apigw.id
  resource_id       = aws_api_gateway_rest_api.apigw.root_resource_id
  http_method       = aws_api_gateway_method.apigw_method.http_method
  status_code       = aws_api_gateway_method_response.success_response.status_code
  selection_pattern = "^2[0-9][0-9]" // regex pattern for any 200 message that comes back from SQS

  response_templates = {
    "application/json" = "{\"message\": \"great success!\"}"
  }

  depends_on = [aws_api_gateway_integration.apigw_integration]
}

# Deploy API
resource "aws_api_gateway_deployment" "apigw_deploy" {
  rest_api_id = aws_api_gateway_rest_api.apigw.id
  stage_name  = "dev"

  depends_on = [
    aws_api_gateway_integration.apigw_integration
  ]
}
