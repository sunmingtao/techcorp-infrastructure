#!/bin/bash

if [[ $# -lt 3 ]]; then
  echo usage: $0 role-name source-bucket target-bucket
	exit 1
fi 

ROLE_NAME=$1
SOURCE_BUCKET=$2
TARGET_BUCKET=$3

cat > tmp-trust-policy.json << 'EOF'
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": { "Service": "s3.amazonaws.com" },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF

echo role name = $ROLE_NAME

aws iam create-role \
  --role-name $ROLE_NAME \
  --assume-role-policy-document file://tmp-trust-policy.json

if [[ $? == 0 ]]; then
  rm tmp-trust-policy.json
fi

cat > tmp-replication-policy.json << EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:GetObjectVersionForReplication",
        "s3:GetObjectVersionAcl",
        "s3:GetObjectVersionTagging"
      ],
      "Resource": "arn:aws:s3:::$SOURCE_BUCKET/*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:ReplicateObject",
        "s3:ReplicateDelete",
        "s3:ReplicateTags"
      ],
      "Resource": "arn:aws:s3:::$TARGET_BUCKET/*"
    }
  ]
}
EOF

echo source bucket = $SOURCE_BUCKET
echo target bucket = $TARGET_BUCKET

aws iam put-role-policy \
  --role-name $ROLE_NAME \
  --policy-name s3-replication-policy \
  --policy-document file://tmp-replication-policy.json

if [[ $? == 0 ]]; then
  rm tmp-replication-policy.json
fi

echo s3 replication role has been created
