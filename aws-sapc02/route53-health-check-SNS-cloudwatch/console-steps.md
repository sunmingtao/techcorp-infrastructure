### Route 53 health check, if unhealthy publish message to SNS topic through cloudwatch

#### Prerequisites

None

#### Steps

Create a SNS topic
  - Amazon SNS -> Create topic
  - Type = Standard (FIFO doesn't support email as endpoint)
  - Create subscription
  - Protocol=Email
  - Confirm subscription in the email

Create Route 53 health check
  - Route 53 -> Health check -> Create health check
  - Resource=Endpoint
  - Specify endpoint by=Domain name
  - Domain=https://www.zzzyyyxxx.com/ (so that the health check fails)
  - View metric in CloudWatch (first time it may not find the resource, try again in a few seconds)
  - Click the health check Id -> Create alarm
  - Period=1 minute
  - Threshold type=Static
  - Whenever HealthCheckStatu is ...=Lower/Equal
  - than...=0
  - Alarm state trigger=In alarm
  - Send a notificaton to the following SNS topic=Select an existing SNS Topic
  - Select the topic
  - Enter message contents

#### Verify

Should receive email notification
