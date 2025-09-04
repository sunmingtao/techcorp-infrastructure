#!/bin/bash

BUCKET=$1

aws s3 rm s3://$BUCKET --recursive
aws s3 rb s3://$BUCKET
