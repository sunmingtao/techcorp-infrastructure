import json
import boto3

def lambda_handler(event, context):
    print("Running post-traffic checks")
    print(f"Event: {json.dumps(event)}")
    
    # Your validation logic here
    validation_passed = True  # Replace with actual validation
    
    # Signal back to CodeDeploy
    codedeploy = boto3.client('codedeploy')
    
    try:
        if validation_passed:
            status = 'Succeeded'
        else:
            status = 'Failed'
            
        response = codedeploy.put_lifecycle_event_hook_execution_status(
            deploymentId=event['DeploymentId'],
            lifecycleEventHookExecutionId=event['LifecycleEventHookExecutionId'],
            status=status
        )
        print(f"Notified CodeDeploy: {status}")
        return response
        
    except Exception as e:
        print(f"Error notifying CodeDeploy: {str(e)}")
        codedeploy.put_lifecycle_event_hook_execution_status(
            deploymentId=event['DeploymentId'],
            lifecycleEventHookExecutionId=event['LifecycleEventHookExecutionId'],
            status='Failed'
        )
        raise
