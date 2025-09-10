#!/bin/bash

for arg in "$@"; do
	POLICIES=$(aws iam list-role-policies --role-name $arg --query "PolicyNames[]" --output text)
  echo policies=$POLICIES 
	for p in $POLICIES; do
		echo delete policy=$p
    aws iam delete-role-policy --role-name $arg --policy-name $p
  done
	aws iam delete-role --role-name $arg
done

echo "roles are deleted"
