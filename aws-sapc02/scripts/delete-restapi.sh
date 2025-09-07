#!/bin/bash

if [[ "$#" < 1 ]]; then
  echo "Usage: $0 api_name"
	exit 1
fi

API_NAME=$1

API_ID=$(aws apigateway get-rest-apis --query "items[?name=='$API_NAME'].id" --output text)

if [[ -z "$API_ID" ]]; then
  echo "$API_NAME" does not exist
else 
  aws apigateway delete-rest-api --rest-api-id "$API_ID"
  echo Deleted "$API_NAME"
fi
