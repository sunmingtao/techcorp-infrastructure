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
'aws ssm start-session --target <instance-id>'

#### check user data script
'aws ec2 describe-instance-attribute --instance-id <your_instance_id> --attribute userData'

