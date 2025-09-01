### Bastion host set up

#### Prerequisites

A public subnet and a private subnet exist

#### Steps

Create an EC2 instance in public subnet
Create an EC2 instance in private subnet


### Verify 1

Run command from local

`ssh -A -i ~/.ssh/techcorp-key.pem ec2-user@34.229.200.170` # -A is agent forwarding

Run command from public ec2 instance

`ssh 10.1.2.5`

### Verify 2

`vi ~/.ssh/config`

```
Host bastion
  HostName 34.229.200.170
  User ec2-user
  IdentityFile ~/.ssh/techcorp-key.pem

Host private-ec2
  HostName 10.1.2.5
  User ec2-user
  IdentityFile ~/.ssh/techcorp-key.pem
  ProxyCommand ssh -W %h:%p bastion
```

Run command from local

`ssh private-ec2`
