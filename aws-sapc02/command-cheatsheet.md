#### check cloudwatch logs

```
aws logs filter-log-events \
  --log-group-name /aws/lambda/weather-health-check-primary
```

#### Watch live logs of a lambda function 

`aws logs tail /aws/lambda/weather-health-check-primary --region us-east-1 --follow`

#### describe organization

`aws organizations describe-organization`

#### log in EC2 using session manager
`aws ssm start-session --target <instance-id>`

#### check user data script
`aws ec2 describe-instance-attribute --instance-id <your_instance_id> --attribute userData`

#### add user profile
`aws configure --profile smt-dev`

#### s3 list bucket using a user profile
`aws s3 ls s3://aws-config-bucket-1756028031 --profile smt-dev`

#### s3 copy bucket object
`aws s3 cp "s3://aws-config-bucket-1756028031/AFP pitch.docx" ./`

#### describe vpc
`aws ec2 describe-vpcs   --query "Vpcs[].Tags[?Key=='Name']|[].Value" --output text`

#### list api gateway
`aws apigatewayv2 get-apis`

#### view api
`aws apigatewayv2 get-api --api-id sxvv85do0a`

#### generate aurora dsql access token
`aws dsql generate-db-connect-auth-token --hostname eeabulk3q5pygqlpkc5hwlnli4.dsql.us-east-1.on.aws`

#### empty a bucket
`aws s3 rm s3://devboard-frontend-627073650332 --recursive`

#### delete an empty bucket
`aws s3 rb s3://devboard-frontend-627073650332`
