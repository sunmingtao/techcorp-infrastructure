#### check cloudwatch logs

```
aws logs filter-log-events \
  --log-group-name /aws/lambda/weather-health-check-primary
```

#### Watch live logs of a lambda function 

`aws logs tail /aws/lambda/weather-health-check-primary --region us-east-1 --follow`

#### describe organization

`aws organizations describe-organization`

