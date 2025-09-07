#!/bin/bash

ROLE=$1

for arg in "$@"; do
	aws iam delete-role --role-name $arg
done

echo "roles are deleted"
