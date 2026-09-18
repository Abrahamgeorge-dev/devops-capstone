resource "aws_s3_bucket" "lambda_deployment" {
  bucket_prefix = "devops-capstone-lambda-"

  tags = {
    Name    = "DevOps Capstone Lambda Deployment"
    Project = "devops-capstone"
  }
}

resource "aws_iam_role" "lambda_role" {
  name = "devops-capstone-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Service = "lambda.amazonaws.com"
        }

        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Name    = "devops-capstone-lambda-role"
    Project = "devops-capstone"
  }
}

resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_lambda_function" "yearbook" {
  function_name = "bloomy-yearbook"

  s3_bucket = aws_s3_bucket.lambda_deployment.id
  s3_key    = "yearbook-lambda-1.0.0.jar"

  handler = "com.Abraham.devops.Application::handleRequest"

  runtime = "java17"

  role = aws_iam_role.lambda_role.arn

  memory_size = 512
  timeout     = 30

  architectures = ["x86_64"]

  tags = {
    Name    = "bloomy-yearbook"
    Project = "devops-capstone"
  }
}

output "lambda_deployment_bucket" {
  description = "S3 bucket used for Lambda deployment"
  value       = aws_s3_bucket.lambda_deployment.bucket
}