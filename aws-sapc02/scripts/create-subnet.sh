#!/bin/bash
set -euo pipefail
# Create a new subnet

log() { printf '%s\n' "$*" >&2; }

log "begin process"

if [[ $# < 1 ]]; then
  log "Usage: $0 subnet-name"
  exit 1
fi

SUBNET_NAME=$1

VPC_OUTPUT=$(get-vpc-id.sh)
read -r CIDR_BLOCK VPC_ID <<< "$VPC_OUTPUT"
log "CIDR BLOCK: $CIDR_BLOCK"
log "VPC ID: $VPC_ID"

SUBNET_CIDR_BLOCKS=$(aws ec2 describe-subnets --filter "Name=vpcId,Values=vpc-0a187bf9f7b3f7c1d" --query "Subnets[].CidrBlock" --output text)

# Get 3 from 10.1.1.0/24 10.1.2.0/24 10.1.3.0/24 (max third octet)
MAX_THIRD=$(printf "%s\n" $SUBNET_CIDR_BLOCKS | awk -F'.' '{print $3}' | sort -nr | head -1)

: "${MAX_THIRD:=0}"
 
NEXT_MAX_THIRD=$((MAX_THIRD + 1))
FIRST_SECOND_OCTET=$(printf "%s" $CIDR_BLOCK | cut -d '.' -f 1,2) # Extract 10.1 from 10.1.3.0/24
NEW_SUBNET_CIDR_BLOCK="$FIRST_SECOND_OCTET.$NEXT_MAX_THIRD.0/24" 

log "new subnet cidr block is $NEW_SUBNET_CIDR_BLOCK"

aws ec2 create-subnet --vpc-id $VPC_ID --cidr-block $NEW_SUBNET_CIDR_BLOCK --tag-specifications 'ResourceType=subnet,Tags=[{Key=Name,Value='$SUBNET_NAME'}]' --query "Subnet.SubnetId" --output text

