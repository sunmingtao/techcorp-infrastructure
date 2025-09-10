### Lambda function reads from parameter store

#### Prerequites 

None

#### Steps

Create a parameter in Parameter Store
- AWS Systems Manager -> Parameter Store -> Create Parameter
- Parameter name = smt-param-1
- Tier = Standard
- Type = string

Create a lambda function 
```
import boto3

ssm = boto3.client("ssm")

def lambda_handler(event, context):
    resp = ssm.get_parameter(
        Name="smt-param-1"
    )
    param_value = resp["Parameter"]["Value"]
    return param_value
```

Add permission to lambda function's role

- Lambda function -> Configuration tab -> Click the role under role name
- Navigate to Role page -> Permissions -> Add permissions -> Attach Policies
- Attach "AmazonSSMFullAccess"

#### Verify

Invoke the lambda function 

`aws lambda invoke   --function-name smt-hello-world  response.json`
