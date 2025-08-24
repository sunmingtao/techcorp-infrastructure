🚀 AWS CROSS-REGION FAILOVER LAB - NO DOMAIN VERSION

This lab demonstrates the weather API failover scenario without requiring a domain name.
Instead of Route 53 failover routing, we use CloudWatch monitoring and EventBridge scheduling
to simulate health checks and demonstrate cross-region redundancy concepts.

💡 KEY LEARNING OBJECTIVES:
✓ Multi-region AWS deployments
✓ DynamoDB Global Tables for data consistency  
✓ API Gateway regional endpoints
✓ Lambda function redundancy
✓ CloudWatch monitoring and alarms
✓ Automated health checking with EventBridge

🛠️ ARCHITECTURE:
┌─────────────┐    ┌─────────────┐
│   PRIMARY   │    │  SECONDARY  │
│  us-east-1  │    │  us-west-2  │
├─────────────┤    ├─────────────┤
│ API Gateway │    │ API Gateway │
│   Lambda    │    │   Lambda    │
│  DynamoDB   │◄──►│  DynamoDB   │
│Health Check │    │Health Check │
└─────────────┘    └─────────────┘
        │                  │
        └──── Global ──────┘
             Tables

🧪 TESTING SCENARIOS:

1. BASIC FUNCTIONALITY:
   • Test both regional endpoints directly
   • Verify responses include region information
   • Confirm APIs work independently

2. DATA SYNCHRONIZATION:
   • Write data to primary region
   • Read same data from secondary region
   • Observe Global Tables replication (usually < 1 second)

3. REGIONAL FAILURE SIMULATION:
   • Disable primary Lambda function in AWS Console
   • Confirm primary API fails
   • Verify secondary API continues working
   • This demonstrates why Route 53 failover is needed in production

4. MONITORING:
   • Watch CloudWatch Logs for health check functions
   • Monitor API Gateway metrics for error rates
   • Observe DynamoDB metrics across regions

📊 COST BREAKDOWN (Per Month):
• Lambda (2 regions): ~$0.02
• API Gateway (2 regions): ~$0.10
• DynamoDB Global Tables: ~$0.20
• CloudWatch Logs/Metrics: ~$0.08
• EventBridge Rules: Free tier
• Total: ~$0.40/month

🔄 PRODUCTION CONSIDERATIONS:
In a real production environment, you would add:
• Route 53 hosted zone and health checks
• Load balancer health checks  
• Custom domain with SSL certificates
• WAF protection
• API throttling and caching
• More sophisticated monitoring/alerting

🧹 CLEANUP:
terraform destroy -auto-approve
