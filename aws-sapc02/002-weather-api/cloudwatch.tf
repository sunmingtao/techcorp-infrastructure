# EventBridge rules for automated health checks
resource "aws_cloudwatch_event_rule" "health_check_primary" {
  provider            = aws.primary
  name                = "weather-health-check-primary"
  description         = "Trigger health check for primary region"
  schedule_expression = "rate(5 minutes)"
  
  tags = {
    Name        = "Health Check Primary Schedule"
    Environment = "lab"
  }
}

resource "aws_cloudwatch_event_rule" "health_check_secondary" {
  provider            = aws.secondary
  name                = "weather-health-check-secondary"
  description         = "Trigger health check for secondary region"
  schedule_expression = "rate(5 minutes)"
  
  tags = {
    Name        = "Health Check Secondary Schedule"
    Environment = "lab"
  }
}

# EventBridge targets
resource "aws_cloudwatch_event_target" "health_check_primary" {
  provider  = aws.primary
  rule      = aws_cloudwatch_event_rule.health_check_primary.name
  target_id = "WeatherHealthCheckPrimaryTarget"
  arn       = aws_lambda_function.health_check_primary.arn
}

resource "aws_cloudwatch_event_target" "health_check_secondary" {
  provider  = aws.secondary
  rule      = aws_cloudwatch_event_rule.health_check_secondary.name
  target_id = "WeatherHealthCheckSecondaryTarget"
  arn       = aws_lambda_function.health_check_secondary.arn
}

# Lambda permissions for EventBridge
resource "aws_lambda_permission" "allow_eventbridge_primary" {
  provider      = aws.primary
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.health_check_primary.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.health_check_primary.arn
}

resource "aws_lambda_permission" "allow_eventbridge_secondary" {
  provider      = aws.secondary
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.health_check_secondary.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.health_check_secondary.arn
}
