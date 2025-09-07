#!/bin/bash

if [[ "$@" < 1 ]]; then
  echo "usage $0 api_key"
  exit 1
fi

KEY_NAME=$1

KEY_ID=$(aws apigateway get-api-keys --query "items[?name=='$KEY_NAME'].id" --output text)

if [[ -z "$KEY_ID" ]]; then
  echo No usage plan is found for name $KEY_NAME
  exit 1
fi 

aws apigateway delete-api-key --api-key $KEY_ID
echo Deleted api key $KEY_NAME
