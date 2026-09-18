resource "aws_apigatewayv2_api" "yearbook" {
  name          = "bloomy-yearbook-api"
  protocol_type = "HTTP"

  target = aws_lambda_function.yearbook.arn

  tags = {
    Name    = "bloomy-yearbook-api"
    Project = "devops-capstone"
  }
}

resource "aws_lambda_permission" "api_gateway" {
  statement_id  = "AllowAPIGatewayInvoke"

  action = "lambda:InvokeFunction"

  function_name = aws_lambda_function.yearbook.function_name

  principal = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.yearbook.execution_arn}/*/*"
}

output "yearbook_api_url" {
  description = "URL for the Bloomy Yearbook application"
  value       = aws_apigatewayv2_api.yearbook.api_endpoint
}