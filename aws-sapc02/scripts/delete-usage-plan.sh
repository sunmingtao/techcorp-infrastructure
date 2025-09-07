#!/bin/bash

if [[ "$@" < 1 ]]; then
  echo "usage $0 usage_plan_name"
  exit 1
fi

PLAN_NAME=$1

PLAN_ID=$(aws apigateway get-usage-plans --query "items[?name=='$PLAN_NAME'].id" --output text)

if [[ -z "$PLAN_ID" ]]; then
  echo No usage plan is found for name $PLAN_NAME
  exit 1
fi 

echo Get the usage plan and delete API stages
aws apigateway get-usage-plan --usage-plan-id $PLAN_ID \
  --query 'apiStages[].{apiId:apiId,stage:stage}' --output text | while read apiId stage; do
    aws apigateway update-usage-plan \
    --usage-plan-id g2pzkp \
    --patch-operations op=remove,path=/apiStages,value=${apiId}:${stage}
  done
aws apigateway delete-usage-plan --usage-plan-id $PLAN_ID
echo Deleted usage plan $PLAN_NAME
