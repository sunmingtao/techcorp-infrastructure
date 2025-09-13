#!/bin/bash
set -eou pipefail
# Create a new subnet and a route table, associate the route table with subnet

log() {
  printf '%s\n' "$*" >&2;
}

if [[ $# < 2 ]]; then
  log "Usage: $0 subnet-name route-table-name"
  exit 1
fi

VPC_OUTPUT=$(get-vpc-id.sh)
read -r CIDR_BLOCK VPC_ID <<< "$VPC_OUTPUT"
log "VPC ID: $VPC_ID"

SUBNET_NAME=$1
ROUTE_TABLE_NAME=$2

SUBNET_ID=$(create-subnet.sh $SUBNET_NAME)

log "New subnet ID is $SUBNET_ID"

ROUTE_TABLE_ID=$(aws ec2 create-route-table --vpc-id $VPC_ID --tag-specifications 'ResourceType=route-table,Tags=[{Key="Name",Value='\"$ROUTE_TABLE_NAME\"'}]' --query "RouteTable.RouteTableId" --output text)

log "New Route table ID is $ROUTE_TABLE_ID"

aws ec2 associate-route-table --route-table-id $ROUTE_TABLE_ID --subnet-id $SUBNET_ID

if [[ $? -eq 0 ]]; then
  log "Created subnet and route table successfully"
else 
  log "Created subnet and route table unsuccessfully"
fi
