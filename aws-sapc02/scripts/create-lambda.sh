#!/bin/bash

if [[ "$#" < 2 ]]; then
  echo "Usage: $0 function_name role_name"
	exit 1
fi

ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
REGION=$(aws configure get region)

echo account_id=$ACCOUNT_ID
echo region=$REGION

FUNCTION_NAME=$1

ROLE_NAME=$2

zip -q function.zip "$FUNCTION_NAME".py

aws lambda create-function \
  --function-name "$FUNCTION_NAME" \
  --runtime python3.13 \
  --handler "$FUNCTION_NAME".lambda_handler \
  --zip-file fileb://"function.zip" \
  --role arn:aws:iam::${ACCOUNT_ID}:role/${ROLE_NAME} \
  --region "$REGION" \
  --query 'FunctionArn' --output text
