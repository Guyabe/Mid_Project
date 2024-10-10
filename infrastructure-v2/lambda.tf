# Create an IAM role for Lambda with the trust relationship
resource "aws_iam_role" "lambda_ssm_role" {
  name = "lambda_ssm_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# Attach the IAM policy that allows interaction with SSM and EC2
resource "aws_iam_policy" "lambda_ssm_policy" {
  name        = "lambda_ssm_policy"
  description = "Policy to allow Lambda to send SSM commands to EC2"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "ssm:SendCommand",
          "ssm:GetCommandInvocation"
        ],
        Resource = [
          "arn:aws:ssm:*:*:document/AWS-RunShellScript",
          "arn:aws:ec2:*:*"
        ]
      },
      {
        Effect = "Allow",
        Action = "logs:*",
        Resource = "*"
      }
    ]
  })
}

# Attach the policy to the role
resource "aws_iam_role_policy_attachment" "lambda_ssm_policy_attachment" {
  role       = aws_iam_role.lambda_ssm_role.name
  policy_arn = aws_iam_policy.lambda_ssm_policy.arn
}

# lambda.tf

resource "aws_lambda_function" "ssm_command_lambda" {
  function_name = "ssm_command_lambda"
  role          = aws_iam_role.lambda_ssm_role.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.8"
  filename      = "${path.module}../application/lambda.zip"

  environment {
    variables = {
      EC2_INSTANCE_ID = var.ec2_instance_id
    }
  }

  # Timeout and memory limits can be set here as needed
  timeout = 60
  memory_size = 128
}

resource "aws_lambda_permission" "allow_cloudwatch" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.ssm_command_lambda.function_name
  principal     = "cloudwatch.amazonaws.com"
}


