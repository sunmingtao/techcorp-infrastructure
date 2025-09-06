#!/bin/bash

API_NAME=smt-hello-throttle-1
STAGE=prod
REGION=$(aws configure get region)

KEY_ID=$(aws apigateway create-api-key \
  --name "${API_NAME}-key" \
  --enabled \
  --region "$REGION" \
  --query 'id' --output text)

# Get the API key value to use in requests
KEY_VALUE=$(aws apigateway get-api-key \
  --api-key "$KEY_ID" \
  --include-value \
  --region "$REGION" \
  --query 'value' --output text)

API_ID=$(aws apigateway get-rest-apis --query "items[?name=='$API_NAME'].id" --output text)

PLAN_ID=$(aws apigateway create-usage-plan \
  --name "${API_NAME}-plan" \
  --throttle burstLimit=2,rateLimit=5 \
  --api-stages apiId=${API_ID},stage=${STAGE} \
  --region "$REGION" \
  --query 'id' --output text)

aws apigateway create-usage-plan-key \
  --usage-plan-id "$PLAN_ID" \
  --key-type "API_KEY" \
  --key-id "$KEY_ID" \
  --region "$REGION"

echo "API Key ID: $KEY_ID"
echo "API Key VALUE: $KEY_VALUE"
