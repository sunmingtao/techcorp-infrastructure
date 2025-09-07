#!/bin/bash

if [[ "$#" < 1 ]]; then
  echo "Usage: $0 api_name"
	exit 1
fi

API_NAME=$1
REGION=$(aws configure get region)

aws apigateway create-rest-api \
  --name "$API_NAME" \
  --region "$REGION"
