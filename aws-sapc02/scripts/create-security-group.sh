#!/bin/bash

if [[ $# -lt 2 ]]; then
  echo usage $0 security_group_name port
  exit 1
fi

if [[ -z "$VPC_NAME" ]]; then
  echo environment varialbe VPC_NAME cannot be found
  exit 1
fi

SG_NAME=$1
PORT=$2

VPC_OUTPUT=$(aws ec2 describe-vpcs --filters "Name=tag:Name,Values=$VPC_NAME" --query "Vpcs[].{VpcId:VpcId,CidrBlock:CidrBlock}" --output text)
read CIDR_BLOCK VPC_ID <<< "$VPC_OUTPUT"

echo "CIDR Block: $CIDR_BLOCK"
echo "VPC ID: $VPC_ID"

GROUP_ID=$(aws ec2 create-security-group --vpc-id $VPC_ID --description $SG_NAME --group-name $SG_NAME --tag-specifications "ResourceType=security-group,Tags=[{Key=Name,Value=$SG_NAME}]" --query "GroupId" --output text)

aws ec2 authorize-security-group-ingress --group-id $GROUP_ID --protocol tcp --port $PORT --cidr $CIDR_BLOCK
