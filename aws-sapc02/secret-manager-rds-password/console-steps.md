### Use Secret Manager to manage RDS database password

#### Prerequisites

An RDS MySQL db exists

#### Steps

- Select the database -> Modify
- Select "Managed in AWS Secrets Manager - most secure"
- AWS Secret Manager -> Select the secret
- Rotation -> Edit rotation
- Turn on "Automatic rotation"
