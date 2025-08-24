# IAM Role for Lambda functions (PRIMARY region)
resource "aws_iam_role" "lambda_role" {
  provider = aws.primary
  name     = "weather-lambda-role"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
  
  tags = {
    Name        = "Weather Lambda Role Primary"
    Environment = "lab"
  }
}

# IAM Role for Lambda functions (SECONDARY region)
resource "aws_iam_role" "lambda_role_secondary" {
  provider = aws.secondary
  name     = "weather-lambda-role-secondary"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
  
  tags = {
    Name        = "Weather Lambda Role Secondary"
    Environment = "lab"
  }
}

# Lambda execution policy for PRIMARY region
resource "aws_iam_role_policy" "lambda_policy_primary" {
  provider = aws.primary
  name     = "weather-lambda-policy-primary"
  role     = aws_iam_role.lambda_role.id
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "arn:aws:logs:*:*:*"
      },
      {
        Effect = "Allow"
        Action = [
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:UpdateItem",
          "dynamodb:DeleteItem",
          "dynamodb:Scan",
          "dynamodb:Query"
        ]
        Resource = [
          aws_dynamodb_table.weather_primary.arn,
          "${aws_dynamodb_table.weather_primary.arn}/*"
        ]
      }
    ]
  })
}

# Lambda execution policy for SECONDARY region
resource "aws_iam_role_policy" "lambda_policy_secondary" {
  provider = aws.secondary
  name     = "weather-lambda-policy-secondary"
  role     = aws_iam_role.lambda_role_secondary.id
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "arn:aws:logs:*:*:*"
      },
      {
        Effect = "Allow"
        Action = [
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:UpdateItem",
          "dynamodb:DeleteItem",
          "dynamodb:Scan",
          "dynamodb:Query"
        ]
        Resource = [
          aws_dynamodb_table.weather_secondary.arn,
          "${aws_dynamodb_table.weather_secondary.arn}/*"
        ]
      }
    ]
  })
}
