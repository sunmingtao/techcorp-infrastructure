#!/bin/bash

DLQ_NAME=smt-dlq-1
MAIN_QUEUE=smt-main-queue-1

# Create DLQ

aws sqs create-queue --queue-name $DLQ_NAME
DLQ_URL=$(aws sqs get-queue-url --queue-name $DLQ_NAME --query QueueUrl --output text)
DLQ_ARN=$(aws sqs get-queue-attributes --queue-url $DLQ_URL --attribute-names QueueArn --query Attributes.QueueArn --output text)

echo created DLQ $DLQ_URL

# Create main queue

aws sqs create-queue --queue-name smt-sql-test-1 --attributes '{RedrivePolicy: "{\"deadLetterTargetArn\":\"'$DLQ_ARN'\",\"maxReceiveCount\":\"3\"}"}'
MAIN_URL=$(aws sqs get-queue-url --queue-name $MAIN_QUEUE --query QueueUrl --output text)

echo created main queue $MAIN_URL

echo Send a bad message 
 
aws sqs send-message --queue-url $MAIN_URL --message-body "bad-job"

echo Simulate a broken worker

for i in {1..4}; do
  echo "Attempt $i"
  aws sqs receive-message --queue-url $MAIN_URL
  sleep 5   # wait so visibility timeout expires
done

# Notes:

# After each receive-message, the message becomes invisible for ~30 seconds (default).
# Since we never call delete-message, the message reappears and is retried.
# After the 3rd receive (per maxReceiveCount), SQS moves it into the DLQ.

echo check DLQ

aws sqs receive-message --queue-url $DLQ_URL

