### Lambda function read environment variable and event 

#### Prerequisites

None

#### Steps

Create a lambda function 

```
import os

def lambda_handler(event, context):
    record_name = os.environ["RECORD_NAME"] 
    event_type = event["RequestType"]
    return record_name, event_type
```

- Lambda -> Functions -> Select the function created
- Configuration tab - Environment variables -> edit
- Key = RECORD_NAME, value = ABC


Test the lambda function

##### console

- Code Tab -> Test button (Below Deploy)
- Payload:
```
{
  "RequestType": "value1"
}
```
- Click Invoke

Response is expected to be 
```
[
  "ABC",
  "value1"
]
```

##### cli

```
echo '{"RequestType":"value1"}' > payload.json
aws lambda invoke --function-name smt-hello-world --payload file://payload.json response.txt
```
