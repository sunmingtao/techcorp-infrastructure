terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.50"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.4"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }
}

# Lambda@Edge functions must be created in us-east-1
provider "aws" {
  region = "us-east-1"
}

# ---- Zip up the Lambda code ----
data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = "${path.module}/lambda"
  output_path = "${path.module}/lambda.zip"
}

# ---- IAM role for Lambda@Edge ----
resource "aws_iam_role" "lambda_edge_role" {
  name = "hello-edge-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = [
          "lambda.amazonaws.com",
          "edgelambda.amazonaws.com"
        ]
      },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "basic_logs" {
  role       = aws_iam_role.lambda_edge_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# ---- Lambda function (publish a version automatically) ----
resource "aws_lambda_function" "hello_edge" {
  function_name = "helloWorldEdge"
  role          = aws_iam_role.lambda_edge_role.arn
  handler       = "index.handler"
  runtime       = "nodejs20.x" # use a Lambda@Edge-supported runtime

  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256

  publish = true   # <- ensures a new immutable version and exposes 'qualified_arn'

  # Do NOT attach to a VPC for Lambda@Edge
  depends_on = [aws_iam_role_policy_attachment.basic_logs]
}

# ---- Dummy S3 origin (won't be hit) ----
resource "random_id" "suffix" {
  byte_length = 4
}

resource "aws_s3_bucket" "dummy" {
  bucket        = "hello-edge-dummy-${random_id.suffix.hex}"
  force_destroy = true
}

# ---- CloudFront distribution with Lambda@Edge association ----
resource "aws_cloudfront_distribution" "demo" {
  enabled             = true
  comment             = "Hello Lambda@Edge demo"

  origin {
    domain_name = aws_s3_bucket.dummy.bucket_regional_domain_name
    origin_id   = "s3-dummy"
  }

  default_cache_behavior {
    target_origin_id       = "s3-dummy"
    viewer_protocol_policy = "redirect-to-https"
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    # Use the published version ARN from the function
    lambda_function_association {
      event_type   = "viewer-request"
      include_body = false
      lambda_arn   = aws_lambda_function.hello_edge.qualified_arn
    }

    min_ttl     = 0
    default_ttl = 0
    max_ttl     = 0
  }

  restrictions {
    geo_restriction { restriction_type = "none" }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}

output "cloudfront_domain_name" {
  value = aws_cloudfront_distribution.demo.domain_name
}

