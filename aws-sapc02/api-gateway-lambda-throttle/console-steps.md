### Create a Rest Gateway API with API Key. Usage plan enables throttling.

#### Prerequisites

- A lambda function exists 

#### Steps 

Create a Rest API

- API Gateway -> APIs -> Create API
- Click Build in REST API section
- API endpoint type = Regional 
- Create resource
- Create method 
- Method type = Get
- Integration type = Lambda function
- Choose the predefined lambda function
- Expand "Method request settings" -> Tick "API key required"
- Deploy API -> New stage
- Stage name = Prod
- Try to access the endpoint should be forbidden. e.g. 
```
INVOKE_URL=https://j6e2no8l51.execute-api.us-east-1.amazonaws.com/prod/hello
curl $INVOKE_URL
{"message":"Forbidden"}
```

Create API key

- API Gateway -> API keys -> Create API Key
- Note down the API Key
`API_KEY=xxxxxxxxx`

Create usage plan

- API Gateway -> Usage plan -> Create usage plan
- Rate=2 (2 requests per second)
- Burst=2 (at any instant, up to 2 requests can pass)
- Turn off Quota
- Select the usage plan -> Add stage
- Select the API defined earlier
- Stage=prod

Add API Key to usage plan

- Select the API key created earlier -> Add to usage plan
- Select the usage plan created earlier


#### Verify

```
curl -H "x-api-key: $API_KEY" "$INVOKE_URL"
```

To test throttling
```
for i in {1..10}; do curl -H "x-api-key: $API_KEY" "$INVOKE_URL"; done
```

expected to see some `{"message":"Too Many Requests"}`

Or run the command at backend, which can produce more `{"message":"Too Many Requests"}`

```
#!/bin/bash

for i in {1..20}; do
  curl -H "x-api-key: $API_KEY" "$INVOKE_URL" &
done
```


