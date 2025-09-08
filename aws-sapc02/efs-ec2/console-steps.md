### Attach an EFS to an EC2 instance

#### Prerequisites

An EC2 instance is running

#### Steps

Create a security group for EFS
- EC2 -> Security Groups -> Create security group
- Inbound rules -> Add rule
- Port range = 2049
- CIDR block = 10.1.0.0/16

Create an EFS
- EFS -> Create file system
- Select the VPC
- Customize (Don't click "Create file system")
- Next (No change in File system settings)
- In Network, change the security group to the one created (don't use default) -> Next
- Next -> Review and Create

SSH to EC2
```
sudo dnf install -y amazon-efs-utils nfs-utils
sudo mkdir -p /mnt/efs
sudo mount -t efs fs-0b79895ac96a1ea7e:/ /mnt/efs   # fs-0b79895ac96a1ea7e is EFS ID
```

#### Verify

`df -h` should see

```
[ec2-user@ip-10-1-1-7 ~]$ df -h
Filesystem      Size  Used Avail Use% Mounted on
.....
127.0.0.1:/     8.0E     0  8.0E   0% /mnt/efs
```
