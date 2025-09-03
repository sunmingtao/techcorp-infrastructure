### Event bridge fires event on EC2 instance state change

#### Prerequisites

- An EC2 instance is running
- An SNS topic exists with email as endpoint

#### Steps

Create an event bridge rule
- Amazon EventBridge -> Rules (Under Buses) -> 
- Rule type = Rule with an event pattern
- Event source = AWS events or EventBridge partner events
- Creation methods = Use pattern form
- Event source = AWS service
- AWS service = EC2
- Event type = EC2 instance state-change Notification
- Event Type Specifiation 1 = Specific states
- Specific states = stopping
- Event Type Specifiation 2 = Any instance 
- Target types = AWS service
- Select a target = SNS topic
- Topic = the created SNS topic 
- Create a new role for this specific resource
  
#### Verify

Should receive email notification

List event bridge rules

`aws events list-rules`

And list targets -- sns, etc

`aws events list-targets-by-rule --rule smt-eventbridge-1`
