### Complete the ASG lifecycle action using lambda function

#### Prerequisites

- An ASG exists with at least one EC2 instance running
- An ASG lifecycle hook exists on Instance termination

#### Steps

Create a lambda function
- Runtime = Python 3.13
- Expand "Change default execution role" -> Select "Create a new role with basic Lambda permissions"
- Note down the new role's name, which will be edited to add new permission
- Lambda function code
```
import json

def lambda_handler(event, context):
    print("Event:", json.dumps(event))
    d = event.get("detail", {})

    params = {
        "LifecycleHookName": d["LifecycleHookName"],
        "AutoScalingGroupName": d["AutoScalingGroupName"],
        "LifecycleActionResult": "CONTINUE",
    }
    if "EC2InstanceId" in d:
        params["InstanceId"] = d["EC2InstanceId"]
    elif "LifecycleActionToken" in d:
        params["LifecycleActionToken"] = d["LifecycleActionToken"]
    else:
        raise RuntimeError("Event missing InstanceId and LifecycleActionToken")

    resp = autoscaling.complete_lifecycle_action(**params)
    print("CompleteLifecycleAction response:", resp)
    return {"ok": True}
```
- Deploy (Save)

Create a new policy that allows complete ASG lifecycle action
- IAM -> Policies -> Create policy
- Service = EC2 Auto Scaling
- Actions allowed = CompleteLifecycleAction
- Resources = All

Attach the policy to the new role created earlier
- IAM -> Role -> Select the new role
- Permssions tab -> Add Permissions -> Attach polices
- Tick the policy created earlier 

Create a EventBridge rule
- Amazon EventBridge -> EventBridge Rule -> Create rule
- Event source = AWS Service
- AWS service = Auto Scaling
- Event type = Instance Launch and Terminate
- Event type specification 1 -> Select "Specifi instance events"
- Tick "EC2 instance-terminate Lifecycle Action"
- Json format:
```
{
  "source": ["aws.autoscaling"],
  "detail-type": ["EC2 Instance-terminate Lifecycle Action"]
}
```
- Target 1 = AWS service
- Select a target  = Lambda function
- Select the lambda function created earlier

#### Verify

Scale in the ASG (Terminate EC2 instance)
- Edit the existing ASG
- Desire capacity = 0, Min capacity = 0, Max capacity = 0
- Instance management tab -> Verify the Lifecycle status of the EC2 instance becomes "Terminating:Wait" -> "Terminating:Proceed" -> Disappar

Check Cloudwatch logs
- Go to the lambda function created earlier
- Monitor -> View CloudWatch logs
- Should see something like below
```
CompleteLifecycleAction response: {'ResponseMetadata': {'RequestId': 'dd772f80-dccc-4a16-9781-ae926e9a2820', 'HTTPStatusCode': 200, 'HTTPHeaders': {'x-amzn-requestid': 'dd772f80-dccc-4a16-9781-ae926e9a2820', 'content-type': 'text/xml', 'content-length': '268', 'date': 'Wed, 03 Sep 2025 07:56:49 GMT'}, 'RetryAttempts': 0}}
```
