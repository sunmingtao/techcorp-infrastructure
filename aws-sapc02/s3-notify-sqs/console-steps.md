### S3 sends event notification to SQS

#### Prerequisites

A S3 bucket exists

#### Steps

Create an SQS
- Amazon SQS -> Queues -> Create quque
- Type = Standard
- Access policy = Advanced
- Paste below policy to allow s3 to send message (Resource is arn:aws:sqs:us-east-1:<acount-number>:<sqs-name>, aws:SourceArn is bucket arn)
```
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "s3.amazonaws.com"
      },
      "Action": "sqs:SendMessage",
      "Resource": "arn:aws:sqs:us-east-1:627073650332:smt-sqs-1",
      "Condition": {
        "ArnLike": {
          "aws:SourceArn": "arn:aws:s3:::aws-config-bucket-1756028031"
        }
      }
    }
  ]
}
```

Create a bucket event notification
- Amazon S3 -> Choose the bucket
- Properties tab -> Scroll down to "Event notification" -> Create event notification
- Event types -> Object creation -> Tick "Put"
- Destination -> destination = SQS queue
- Choose the SQS queue created earlier 

#### Verify

- Upload a file to the bucket 
- Select the SQS queue -> Send and receive messages -> Poll for messages
- Should see messages in the messages table
