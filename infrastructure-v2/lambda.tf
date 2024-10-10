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
