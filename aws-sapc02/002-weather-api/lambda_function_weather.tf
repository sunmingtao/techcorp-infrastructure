# Lambda function source code (updated for Function URLs)
data "archive_file" "lambda_zip" {
  type        = "zip"
  output_path = "weather_lambda.zip"
  
  source {
    content = <<EOF
import json
import boto3
import os
from datetime import datetime
import urllib.parse

def lambda_handler(event, context):
    region = os.environ.get('AWS_REGION')
    dynamodb = boto3.resource('dynamodb')
    
    # Use the same table name in both regions (Global Tables requirement)
    table_name = "weather-data"
    table = dynamodb.Table(table_name)
    
    try:
        # Debug: Print the entire event to understand the structure
        print(f"DEBUG: Event structure: {json.dumps(event, indent=2)}")
        
        # Extract HTTP method and path from Lambda Function URL event
        # Function URL event structure is different from API Gateway
        request_context = event.get('requestContext', {})
        http_info = request_context.get('http', {})
        http_method = http_info.get('method', 'GET')
        raw_path = event.get('rawPath', '/')
        
        print(f"DEBUG: Method={http_method}, Path={raw_path}")
        
        # Parse the path to extract location if present
        # Expected paths: /sydney, /weather/sydney, or /
        path_parts = [part for part in raw_path.split('/') if part]
        print(f"DEBUG: Path parts: {path_parts}")
        
        if http_method == 'GET':
            # GET request - retrieve weather data
            if len(path_parts) >= 1:
                # Path like /sydney or /weather/sydney
                if path_parts[0] == 'weather' and len(path_parts) >= 2:
                    location = urllib.parse.unquote(path_parts[1])
                else:
                    location = urllib.parse.unquote(path_parts[0])
            else:
                # Root path /
                location = 'default'
            
            print(f"DEBUG: Looking up location: {location}")
            
            # Try to get from database
            response = table.get_item(Key={'location': location})
            
            if 'Item' in response:
                result = {
                    'location': response['Item']['location'],
                    'temperature': response['Item'].get('temperature', 'N/A'),
                    'humidity': response['Item'].get('humidity', 'N/A'),
                    'region': region,
                    'timestamp': response['Item'].get('timestamp', 'N/A'),
                    'source': 'database'
                }
            else:
                # Return sample data if not found
                result = {
                    'location': location,
                    'temperature': '22°C',
                    'humidity': '65%',
                    'region': region,
                    'timestamp': datetime.now().isoformat(),
                    'source': 'sample_data',
                    'note': f'Sample data - location "{location}" not found in database'
                }
            
            # Add debug info
            result['debug_info'] = {
                'raw_path': raw_path,
                'parsed_location': location,
                'method': http_method,
                'path_parts': path_parts
            }
            
            return {
                'statusCode': 200,
                'headers': {
                    'Content-Type': 'application/json',
                    'Access-Control-Allow-Origin': '*'
                },
                'body': json.dumps(result, indent=2)
            }
        
        elif http_method == 'POST':
            # POST request - store weather data
            body_str = event.get('body', '{}')
            
            # Handle both string and already-parsed JSON
            if isinstance(body_str, str):
                body = json.loads(body_str) if body_str else {}
            else:
                body = body_str
            
            print(f"DEBUG: POST body: {body}")
            
            # Validate required fields
            if 'location' not in body:
                return {
                    'statusCode': 400,
                    'headers': {
                        'Content-Type': 'application/json',
                        'Access-Control-Allow-Origin': '*'
                    },
                    'body': json.dumps({
                        'error': 'Missing required field: location',
                        'required_format': {
                            'location': 'string (required)',
                            'temperature': 'string (optional)',
                            'humidity': 'string (optional)'
                        },
                        'example': {
                            'location': 'sydney',
                            'temperature': '25°C',
                            'humidity': '70%'
                        },
                        'region': region
                    }, indent=2)
                }
            
            item = {
                'location': body['location'],
                'temperature': body.get('temperature', 'N/A'),
                'humidity': body.get('humidity', 'N/A'),
                'timestamp': datetime.now().isoformat()
            }
            
            table.put_item(Item=item)
            
            return {
                'statusCode': 201,
                'headers': {
                    'Content-Type': 'application/json',
                    'Access-Control-Allow-Origin': '*'
                },
                'body': json.dumps({
                    'message': f'Weather data stored successfully in {region}',
                    'item': item,
                    'note': 'Data will sync to other regions via DynamoDB Global Tables within seconds'
                }, indent=2)
            }
        
        else:
            # Handle other HTTP methods
            return {
                'statusCode': 405,
                'headers': {
                    'Content-Type': 'application/json',
                    'Access-Control-Allow-Origin': '*',
                    'Allow': 'GET, POST'
                },
                'body': json.dumps({
                    'error': f'Method {http_method} not allowed',
                    'supported_methods': ['GET', 'POST'],
                    'region': region,
                    'examples': {
                        'GET': 'curl https://your-function-url.lambda-url.region.on.aws/sydney',
                        'POST': 'curl -X POST https://your-function-url.lambda-url.region.on.aws/ -H "Content-Type: application/json" -d \'{"location": "sydney", "temperature": "25°C"}\''
                    }
                }, indent=2)
            }
    
    except json.JSONDecodeError as e:
        return {
            'statusCode': 400,
            'headers': {
                'Content-Type': 'application/json',
                'Access-Control-Allow-Origin': '*'
            },
            'body': json.dumps({
                'error': 'Invalid JSON in request body',
                'details': str(e),
                'region': region,
                'received_body': event.get('body', 'No body')
            }, indent=2)
        }
    except Exception as e:
        return {
            'statusCode': 500,
            'headers': {
                'Content-Type': 'application/json',
                'Access-Control-Allow-Origin': '*'
            },
            'body': json.dumps({
                'error': 'Internal server error',
                'details': str(e),
                'region': region,
                'event_debug': {
                    'has_requestContext': 'requestContext' in event,
                    'has_rawPath': 'rawPath' in event,
                    'has_body': 'body' in event,
                    'event_keys': list(event.keys())
                }
            }, indent=2)
        }
EOF
    filename = "lambda_function.py"
  }
}
