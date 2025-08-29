### Create an auto scaling group

#### Prerequites

1. 1 or 2 public subnet exists

Create a launch template
  Tick "Auto Scaling guidance"
  Select an Amazon Linux as AMI
  Instance type = t2.micro"
  Subnet = "Don't include in launch template"
  Expand Advanced details -> User data
    #!/bin/bash
    yum update -y
    yum install -y httpd
    systemctl start httpd
    systemctl enable httpd
    echo "Hello from Auto Scaling" > /var/www/html/index.html

Create an auto scaling group
   select the launch template
   select custom VPC
   select all public subnets
   No load balancer
   Desired capacity = 2
   Min desired capacity = 2
   Max desired capacity = 4
   Select "Target tracking scaling policy" -> leave default value
   
#### Verify

Check if two instances are running
Manually terminate one instance and a new instance should be created 
Set Desired capacity to 0 and Min desired capacity to 0, and all instances will be terminated
