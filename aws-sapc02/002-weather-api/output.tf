# Outputs
output "primary_api_url" {
  description = "Primary region Lambda Function URL"
  value = aws_lambda_function_url.weather_primary.function_url
}

output "secondary_api_url" {
  description = "Secondary region Lambda Function URL"
  value = aws_lambda_function_url.weather_secondary.function_url
}

output "primary_health_check_url" {
  description = "Primary region health check Lambda function URL"
  value = aws_lambda_function.health_check_primary.function_name
}

output "secondary_health_check_url" {
  description = "Secondary region health check Lambda function URL"
  value = aws_lambda_function.health_check_secondary.function_name
}

output "test_commands" {
  description = "Commands to test the simplified APIs"
  value = <<EOF

🚀 SIMPLIFIED API TESTING COMMANDS:

# Test Primary Region:
curl "${aws_lambda_function_url.weather_primary.function_url}sydney"
curl "${aws_lambda_function_url.weather_primary.function_url}weather/sydney"

# Test Secondary Region:
curl "${aws_lambda_function_url.weather_secondary.function_url}sydney"
curl "${aws_lambda_function_url.weather_secondary.function_url}weather/sydney"

# Post data to Primary:
curl -X POST "${aws_lambda_function_url.weather_primary.function_url}" \
  -H "Content-Type: application/json" \
  -d '{"location": "sydney", "temperature": "25°C", "humidity": "70%"}'

# Post data to Secondary:
curl -X POST "${aws_lambda_function_url.weather_secondary.function_url}" \
  -H "Content-Type: application/json" \
  -d '{"location": "melbourne", "temperature": "18°C", "humidity": "80%"}'

# Test Global Tables sync:
# 1. POST to primary region
# 2. GET from secondary region (should see the same data!)

EOF
}

output "lab_instructions" {
  description = "Step-by-step lab instructions for simplified version"
  value = <<EOF

🚀 WEATHER API FAILOVER LAB - SIMPLIFIED VERSION

📋 WHAT WE REMOVED:
❌ Complex API Gateway setup (20+ resources)
❌ Multiple layers of resources/methods/integrations
❌ Complicated permissions

✅ WHAT WE ADDED:
✅ Lambda Function URLs (2 resources total!)
✅ Direct HTTPS endpoints
✅ Same failover learning concepts
✅ Much cleaner code

🛠️ ARCHITECTURE:
┌─────────────┐    ┌─────────────┐
│   PRIMARY   │    │  SECONDARY  │
│  us-east-1  │    │  us-west-2  │
├─────────────┤    ├─────────────┤
│   Lambda    │    │   Lambda    │
│Function URL │    │Function URL │
│  DynamoDB   │◄──►│  DynamoDB   │
│Health Check │    │Health Check │
└─────────────┘    └─────────────┘
        │                  │
        └──── Global ──────┘
             Tables

📋 SETUP:
1. terraform init
2. terraform apply
3. Wait for deployment (2-3 minutes - much faster!)

🧪 TESTS:

Test 1 - Basic Functionality:
• Use the curl commands above
• Notice how much simpler the URLs are
• Verify both regions return weather data

Test 2 - Path Flexibility:
• Try: /sydney, /weather/sydney, /melbourne
• Function URLs handle paths more flexibly

Test 3 - Data Synchronization:
• Post weather data to primary region
• Read same data from secondary region
• Observe Global Tables sync (< 1 second)

Test 4 - Simulate Regional Failure:
• Go to AWS Console → Lambda
• Delete or disable primary Lambda function
• Test primary URL - should fail
• Test secondary URL - should still work

Test 5 - Error Handling:
• Try invalid JSON in POST request
• Try unsupported HTTP methods (PUT, DELETE)
• See helpful error messages with region info

📊 BENEFITS OF SIMPLIFIED VERSION:
• 85% fewer Terraform resources
• 50% faster deployment
• Built-in HTTPS (no certificates needed)
• Easier debugging
• Same learning outcomes
• Lower cost (no API Gateway charges)

💰 COSTS (Per Month):
• Lambda (2 regions): ~$0.02
• DynamoDB Global Tables: ~$0.20
• CloudWatch Logs/Metrics: ~$0.05
• Function URLs: FREE!
• Total: ~$0.27/month (vs $0.40 with API Gateway)

🔄 PRODUCTION CONSIDERATIONS:
For production, you might add back:
• Custom domain names
• API Gateway for more advanced features
• Authentication/authorization
• Rate limiting and throttling
• Request/response transformation

🧹 CLEANUP:
terraform destroy -auto-approve

✨ KEY LEARNING: 
You can learn AWS failover concepts without getting bogged down in API Gateway complexity!
Start simple, then add complexity when you need specific features.

EOF
}
