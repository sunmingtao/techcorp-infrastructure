# Primary region Lambda function
resource "aws_lambda_function" "weather_primary" {
  provider         = aws.primary
  filename         = data.archive_file.lambda_zip.output_path
  function_name    = "weather-api-primary"
  role            = aws_iam_role.lambda_role.arn
  handler         = "lambda_function.lambda_handler"
  runtime         = "python3.9"
  timeout         = 30
  
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  
  environment {
    variables = {
      REGION = var.primary_region
    }
  }
  
  tags = {
    Name        = "Weather API Primary"
    Environment = "lab"
  }
}

# Secondary region Lambda function
resource "aws_lambda_function" "weather_secondary" {
  provider         = aws.secondary
  filename         = data.archive_file.lambda_zip.output_path
  function_name    = "weather-api-secondary"
  role            = aws_iam_role.lambda_role_secondary.arn
  handler         = "lambda_function.lambda_handler"
  runtime         = "python3.9"
  timeout         = 30
  
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  
  environment {
    variables = {
      REGION = var.secondary_region
    }
  }
  
  tags = {
    Name        = "Weather API Secondary"
    Environment = "lab"
  }
}

# Lambda Function URLs (Simple API endpoints)
resource "aws_lambda_function_url" "weather_primary" {
  provider           = aws.primary
  function_name      = aws_lambda_function.weather_primary.function_name
  authorization_type = "NONE"  # Public access - fine for learning

  cors {
    allow_credentials = false
    allow_origins     = ["*"]
    allow_methods     = ["GET", "POST", "PUT", "DELETE"]
    allow_headers     = ["date", "keep-alive", "content-type"]
    expose_headers    = ["date", "keep-alive"]
    max_age          = 86400
  }

}

resource "aws_lambda_function_url" "weather_secondary" {
  provider           = aws.secondary
  function_name      = aws_lambda_function.weather_secondary.function_name
  authorization_type = "NONE"

  cors {
    allow_credentials = false
    allow_origins     = ["*"]
    allow_methods     = ["GET", "POST", "PUT", "DELETE"]
    allow_headers     = ["date", "keep-alive", "content-type"]
    expose_headers    = ["date", "keep-alive"]
    max_age          = 86400
  }

}

# Health check Lambda for monitoring API health
resource "aws_lambda_function" "health_check_primary" {
  provider         = aws.primary
  filename         = data.archive_file.health_check_zip.output_path
  function_name    = "weather-health-check-primary"
  role            = aws_iam_role.lambda_role.arn
  handler         = "lambda_function.lambda_handler"
  runtime         = "python3.9"
  timeout         = 30

  source_code_hash = data.archive_file.health_check_zip.output_base64sha256

  environment {
    variables = {
		  API_URL = aws_lambda_function_url.weather_primary.function_url
    }
  }

  tags = {
    Name        = "Health Check Primary"
    Environment = "lab"
  }
}

resource "aws_lambda_function" "health_check_secondary" {
  provider         = aws.secondary
  filename         = data.archive_file.health_check_zip.output_path
  function_name    = "weather-health-check-secondary"
  role            = aws_iam_role.lambda_role_secondary.arn
  handler         = "lambda_function.lambda_handler"
  runtime         = "python3.9"
  timeout         = 30

  source_code_hash = data.archive_file.health_check_zip.output_base64sha256

  environment {
    variables = {
      API_URL = aws_lambda_function_url.weather_primary.function_url
    }
  }

  tags = {
    Name        = "Health Check Secondary"
    Environment = "lab"
  }
}

# Health check function source
data "archive_file" "health_check_zip" {
  type        = "zip"
  output_path = "health_check.zip"

  source {
    content = <<EOF
import json
import urllib3
import os

def lambda_handler(event, context):
    api_url = os.environ['API_URL']
    http = urllib3.PoolManager()

    try:
        # Test the health of the API by calling a sample endpoint
        response = http.request('GET', f"{api_url}/weather/health-check")

        if response.status == 200:
            return {
                'statusCode': 200,
                'headers': {
                    'Content-Type': 'application/json',
                    'Access-Control-Allow-Origin': '*'
                },
                'body': json.dumps({
                    'status': 'healthy',
                    'api_url': api_url,
                    'region': os.environ.get('AWS_REGION', 'unknown')
                })
            }
        else:
            return {
                'statusCode': 500,
                'headers': {
                    'Content-Type': 'application/json',
                    'Access-Control-Allow-Origin': '*'
                },
                'body': json.dumps({
                    'status': 'unhealthy',
                    'api_url': api_url,
                    'region': os.environ.get('AWS_REGION', 'unknown'),
                    'response_status': response.status
                })
            }
    except Exception as e:
        return {
            'statusCode': 500,
            'headers': {
                'Content-Type': 'application/json',
                'Access-Control-Allow-Origin': '*'
            },
            'body': json.dumps({
                'status': 'unhealthy',
                'error': str(e),
                'api_url': api_url,
                'region': os.environ.get('AWS_REGION', 'unknown')
            })
        }
EOF
    filename = "lambda_function.py"
  }
}
