resource "aws_lambda_function" "pricing_demo" {
  filename         = "pricing.zip"
  function_name    = "pricing_demo"
  role             = aws_iam_role.pricing_demo.arn
  handler          = "pricing.handler"
  runtime          = "python3.10"
  timeout          = 30
  memory_size      = 128

  environment {
    variables = {
      SEED = "1234"
    }
  }

  tags = {
    Name = "pricing_demo"
  }

  vpc_config {
    subnet_ids         = [aws_subnet.pricing_demo.id]
    security_group_ids = [aws_security_group.pricing_demo.id]
  }
  
  depends_on = [aws_iam_role_policy_attachment.pricing_demo_eni_attachment]
}

resource "aws_lambda_function_url" "pricing_demo_url" {
  function_name      = aws_lambda_function.pricing_demo.function_name
  authorization_type = "NONE"

  cors {
    allow_origins = ["*"]
  }
}

resource "aws_lambda_permission" "allow_function_url" {
  statement_id        = "AllowExecutionFromURL"
  action              = "lambda:InvokeFunctionUrl"
  function_name       = aws_lambda_function.pricing_demo.function_name
  principal           = "*"
  function_url_auth_type = "NONE"
}

output "lambda_function_url" {
  value = aws_lambda_function_url.pricing_demo_url.function_url
}