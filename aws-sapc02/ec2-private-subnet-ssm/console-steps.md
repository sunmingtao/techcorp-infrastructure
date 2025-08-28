### Launch an EC2 instance in private subnet and allow the EC2 instance to reach Internet through NAT Gateway

#### Prerequites

1. A public subnet exists (with route table connecting to Internet Gateway)

#### Steps

1. Create a private subnet
2. Create a NAT gateway (connectivity type: public)
3. Allocate Elastic IP (If selected private, then cannot see this field on the form)
4. Create route table and associate it with the private subnet
5. Add a new route (Destination=0.0.0.0/0, Target=NAT Gateway)
6. Launch an EC2 instance
     Select "Amazon Linux AWS" as AMI (don't select Red Hat as it doesn't have SSM Agent preinstalled)
     for Key pair name, select "Proceed without a keypair (not recommended"
     Select the VPC created ealier (Don't use the default one)
     Select the private subnet
     Create a new security role (allow SSH traffic from anywhere)
     Click Launch instance 
  
7. Add the role to the EC2 instance (Action -> Security -> Modify IAM Role)
8. Reboot the EC2 instance (to let the SSM agent pick up the role)

#### Test

EC2 instance dashboard -> select the EC2 instance -> Connect -> "Session Manager" tab -> Click "Connect"
