### Create an Auto Scaling Group lifecycle hook

#### Prerequisites

- An ASG exists with at least one EC2 instance running

#### Steps

Create an ASG lifecycle hook-1
- EC2 -> Auto Scaling Groups -> Select the existing ASG
- Instance management -> Create lifecycle hook
- Lifecycle transition = Instance terminate
- Heartbeat timeout = 600
- Default result = CONTINUE

Scale in the ASG (Terminate EC2 instance)
- Edit the existing ASG
- Desire capacity = 0, Min capacity = 0, Max capacity = 0
- Instance management tab -> Verify the Lifecycle status of the EC2 instance becomes "Terminating:Wait"

Complete the lifecycle action (Only through CLI, not in the console)

```
aws autoscaling complete-lifecycle-action   --lifecycle-hook-name smt-asg-hook-1   --auto-scaling-group-name smt-asg-1   --instance-id i-0aafb7229bcfc66a6   --lifecycle-action-result CONTINUE
```

#### Verify

ASG -> Instance management tab -> verify the EC2 instance is gone. 
