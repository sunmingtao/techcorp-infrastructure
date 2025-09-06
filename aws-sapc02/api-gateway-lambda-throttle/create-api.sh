#!/bin/bash

ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
REGION=$(aws configure get region)
API_NAME=smt-hello-throttle-1
FUNCTION_NAME=smt-hello-world
STAGE=prod

API_ID=$(aws apigateway create-rest-api \
  --name "$API_NAME" \
  --region "$REGION" \
  --query 'id' --output text)

ROOT_ID=$(aws apigateway get-resources \
  --rest-api-id "$API_ID" \
  --region "$REGION" \
  --query 'items[?path==`/`].id' --output text)

RES_ID=$(aws apigateway create-resource \
  --rest-api-id "$API_ID" \
  --parent-id "$ROOT_ID" \
  --path-part hello \
  --region "$REGION" \
  --query 'id' --output text)

# Require API key on GET /hello
aws apigateway put-method \
  --rest-api-id "$API_ID" \
  --resource-id "$RES_ID" \
  --http-method GET \
  --authorization-type "NONE" \
  --api-key-required \
  --region "$REGION"

# Lambda proxy integration
aws apigateway put-integration \
  --rest-api-id "$API_ID" \
  --resource-id "$RES_ID" \
  --http-method GET \
  --type AWS \
  --integration-http-method POST \
  --uri arn:aws:apigateway:${REGION}:lambda:path/2015-03-31/functions/arn:aws:lambda:${REGION}:${ACCOUNT_ID}:function:${FUNCTION_NAME}/invocations \
  --region "$REGION"

# Allow API Gateway to invoke your Lambda
aws lambda add-permission \
  --function-name "$FUNCTION_NAME" \
  --statement-id apigw-${API_ID}-${STAGE} \
  --action lambda:InvokeFunction \
  --principal apigateway.amazonaws.com \
  --source-arn arn:aws:execute-api:${REGION}:${ACCOUNT_ID}:${API_ID}/*/GET/hello \
  --region "$REGION"

# Deploy to stage
aws apigateway create-deployment \
  --rest-api-id "$API_ID" \
  --stage-name "$STAGE" \
  --region "$REGION" >/dev/null

INVOKE_URL="https://${API_ID}.execute-api.${REGION}.amazonaws.com/${STAGE}/hello"
echo "Invoke URL: $INVOKE_URL"

