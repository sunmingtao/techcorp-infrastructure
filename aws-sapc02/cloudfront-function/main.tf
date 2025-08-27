# Lambda@Edge functions must be created in us-east-1
provider "aws" {
  region = "us-east-1"
}

resource "aws_cloudfront_function" "hello_fn" {
  name    = "hello-cf-fn"
  runtime = "cloudfront-js-1.0"
  comment = "Hello World CloudFront Function"

  publish = true

  code = <<EOT
function handler(event) {
    var response = {
        statusCode: 200,
        statusDescription: 'OK',
        headers: {
            'content-type': { value: 'text/plain; charset=utf-8' },
        },
        body: 'Hello from CloudFront Function 👋',
    };
    return response;
}
EOT
}

data "aws_s3_bucket" "existing-config-bucket" {
  bucket = "aws-config-bucket-1756028031"
}

resource "aws_cloudfront_distribution" "demo" {

  enabled             = true
  comment             = "Hello world cloudfront function"

  origin {
    domain_name = data.aws_s3_bucket.existing-config-bucket.bucket_regional_domain_name
    origin_id   = "s3-config-dummy-bucket"
  }

  default_cache_behavior {
    target_origin_id       = "s3-config-dummy-bucket"
    viewer_protocol_policy = "redirect-to-https"
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    
    function_association {
      event_type   = "viewer-request"
      function_arn = aws_cloudfront_function.hello_fn.arn
    }

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

  }
  restrictions {     
	  geo_restriction { restriction_type = "none" }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}
