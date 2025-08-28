### Launch an EC2 instance in public subnet and connect to it via SSM (Session Manager)

#### Prerequisites

An AWS account (do not use the root account for everyday tasks).
An IAM user with sufficient permissions (e.g., AdministratorAccess 
or equivalent custom policy) to create VPCs, subnets, EC2 instances, IAM roles, and attach policies.

#### Steps 

1. Create a VPC
2. Create a subnet (tick "Auto-assign public IPv4 address")
3. Create a Internet Gateway and attach it to VPC
3. Create a route table and associate the route table with the subnet
4. Add a new route (Destination=0.0.0.0/0, Target=Internet Gateway)
5. Launch an EC2 instance
     Select "Amazon Linux AWS" as AMI (don't select Red Hat as it doesn't have SSM Agent preinstalled)
     for Key pair name, select "Proceed without a keypair (not recommended)"
     Select the VPC created ealier (Don't use the default one)
     Select the public subnet
     Create a new security role (allow SSH traffic from anywhere)
     Click Launch instance
6. Create an IAM role
     Add policy AmazonSSMManagedInstanceCore
7. Add the role to the EC2 instance (Action -> Security -> Modify IAM Role)
8. Reboot the EC2 instance (to let the SSM agent pick up the role)

#### Test

EC2 instance dashboard -> select the EC2 instance -> Connect -> "Session Manager" tab -> Click "Connect"
