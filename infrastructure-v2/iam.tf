resource "aws_iam_role" "ec2_role" {
  name = "ec2_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action    = "sts:AssumeRole",
      Effect    = "Allow",
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })

  tags = merge(local.tags, { Name = "${local.tags.Environment}-ec2-role" })
}

resource "aws_iam_policy" "ec2_policy" {
  name        = "ec2_dynamodb_policy"
  description = "Policy for EC2 instances to access DynamoDB"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action   = [
        "dynamodb:GetItem",
        "dynamodb:Query",
        "dynamodb:Scan",
        "dynamodb:PutItem"
      ],
      Effect   = "Allow",
      Resource = "*" 
    }]
  })

  tags = merge(local.tags, { Name = "${local.tags.Environment}-ec2-policy" })
}

resource "aws_iam_role_policy_attachment" "ec2_policy_attachment" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2_instance_profile"
  role = aws_iam_role.ec2_role.name

  tags = merge(local.tags, { Name = "${local.tags.Environment}-ec2-instance-profile" })
}
