#!/bin/bash

ROLE=$1

aws iam create-role --role-name "$1" --assume-role-policy-document file:///home/msun/techcorp-infrastructure/aws-sapc02/scripts/lambda-trust.json

aws iam attach-role-policy \
  --role-name "$1" \
  --policy-arn arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole
