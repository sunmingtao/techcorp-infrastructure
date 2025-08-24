# DynamoDB Tables with Global Table configuration
# Primary region table

resource "aws_dynamodb_table" "weather_primary" {
  provider     = aws.primary
  name         = "weather-data"  # Same name in both regions!
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "location"
  
  attribute {
    name = "location"
    type = "S"
  }
  
  stream_enabled   = true
  stream_view_type = "NEW_AND_OLD_IMAGES"
  
  tags = {
    Name        = "Weather Data Primary"
    Environment = "lab"
  }
}

# Secondary region table (SAME NAME!)
resource "aws_dynamodb_table" "weather_secondary" {
  provider     = aws.secondary
  name         = "weather-data"  # Same name in both regions!
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "location"
  
  attribute {
    name = "location"
    type = "S"
  }
  
  stream_enabled   = true
  stream_view_type = "NEW_AND_OLD_IMAGES"
  
  tags = {
    Name        = "Weather Data Secondary" 
    Environment = "lab"
  }
}

# Global Table configuration (links the existing tables)
resource "aws_dynamodb_global_table" "weather_global" {
  provider = aws.primary
  name     = "weather-data"  # References existing table name
  
  replica {
    region_name = var.primary_region
  }
  replica {
    region_name = var.secondary_region
  }
  
  depends_on = [
    aws_dynamodb_table.weather_primary,
    aws_dynamodb_table.weather_secondary
  ]
}
