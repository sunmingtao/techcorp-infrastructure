### Create a S3 bucket permission policy 

#### Prerequisites

None

#### Steps 

Create a new user without admin access
  IAM -> Users -> Create user
  Tick "Provide user access to the AWS Management Console"
  Select "I want to create an IAM user"
  Next -> Click "Create user" button
  Return to user list -> select the user created
  "Security credentials" tab -> Access Keys
  Create access key
  Use case = Command Line Interface
  Download .csv file -> Done
  
Create a policy
  IAM -> Policies -> Create Policy
  Choose service: S3
  Actions allowed: Tick ListBucket
  Resources -> Bucket -> Add ARNs-> Enter Bucket name
  Add more permissions
  Choose service: S3
  Actions allowed: Tick GetObject
  Resources -> Object -> Add ARNs
    Bucket name: Enter bucket name
	Object name: Tick Any object name
	
  The policy's json format:
  ```
  {
	"Version": "2012-10-17",
	"Statement": [
		{
			"Sid": "VisualEditor0",
			"Effect": "Allow",
			"Action": "s3:ListBucket",
			"Resource": "arn:aws:s3:::aws-config-bucket-1756028031"
		},
		{
			"Sid": "VisualEditor1",
			"Effect": "Allow",
			"Action": "s3:GetObject",
			"Resource": "arn:aws:s3:::aws-config-bucket-1756028031/*"
		}
	]
  }
  ```
  
Attach policy to the user
  Users -> Select the user created
  Permission tab -> Add permission -> Attach policies directly
  Select the policy created -> Add permission


#### Verify 

```
aws configure --profile smt-dev # new user
aws s3 ls s3://aws-config-bucket-1756028031 --profile smt-dev # bucket name
aws s3 cp "s3://aws-config-bucket-1756028031/AFP pitch.docx" ./ --profile smt-dev
```
