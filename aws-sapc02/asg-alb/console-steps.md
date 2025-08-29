### Create auto scaling group fronted by Application Load Balancer

#### Prerequites

1 or 2 subnets exist
A launch template exists

#### Steps

Create a target group
  Target type = instances
  VPC = custom VPC
  Don't register any instance
 
Create an Application Load Balancer
  VPC = custom VPC
  Select both subnets
  Select or create a new security group
  Listener -> Default action -> Select the target group created

Create an auto scaling group
  Select a launch template
  VPC = custom VPC
  Select both subnets
  Load balancing -> Attach to exist load balancer -> Select the ALB created
  Desired capacity = 2
  Min desired capacity = 2
  Max desired capacity = 4
  Select "Target tracking scaling policy" -> leave default value
  
#### Verify
  Select the target group and verify there are two instances registered. 
