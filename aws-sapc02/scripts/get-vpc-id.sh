#!/bin/bash
set -euo pipefail

log() {
  printf '%s\n' "$*" >&2;
}

if [[ -z ${VPC_NAME-} ]]; then
  log "environment varialbe $VPC_NAME cannot be found"
  exit 1
fi

aws ec2 describe-vpcs --filters "Name=tag:Name,Values=$VPC_NAME" --query "Vpcs[].{VpcId:VpcId,CidrBlock:CidrBlock}" --output text
