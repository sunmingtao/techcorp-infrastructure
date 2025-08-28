### Create two subnets on different zones, launch one EC2 instance on each subnet with user-data script
that accepts http request on port 80. Including a /health checkpoint as well

#### Prerequites

Two EC2 instances exist on two subnets 

#### Steps

Create a target group
  target type = instances
  Protocl = HTTP
  Port = 80
  VPC = custom VPC
  Select two running instances -> Include as pending below -> Create target group
  
Create a security group for ALB
  Inbound rules
    Type=HTTP
	Source=0.0.0.0/0
  Outbound rules
    Type=HTTP 
    Destination=EC2 security group

Modify EC2 security group
  Add Inbound rules
    Type=HTTP
    Source=ALB security group	
	
Create Application Load Balancer
  Scheme=Internet-facing
  VPC=custom VPC
  Availability Zones=tick two zone and select the subnet
  Security Group=ALB security group
  Default action=Forward to target group 
  
  
#### Verify

`curl <ALB-endpoint>`
e.g. `curl smt-alb-1-1439497827.us-east-1.elb.amazonaws.com`
