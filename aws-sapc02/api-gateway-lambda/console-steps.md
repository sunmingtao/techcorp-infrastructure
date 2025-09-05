### Gateway API + Lambda

#### Prerequisites

None

#### Steps

Create a lambda function
  Runtime=Node.js 22
  Modify the code and click deploy
  
Create an API gateway
  API Gateway -> Create an API
  Build HTTP API (Not Rest API)
  Integration -> Lambda -> Select the lambda function we created 
  Configure routes
    Method: Get
	Resource path: /
	Integration target: the lambda function
  
#### Verify 

curl <default-endpoint> # e.g. https://9qnlnestjh.execute-api.us-east-1.amazonaws.com/
