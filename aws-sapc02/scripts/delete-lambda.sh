#!/bin/bash

for arg in "$@"; do
  aws lambda delete-function --function-name $arg
done

echo "lambda function deleted"
