## Build Route 53 Private Hosted Zone with Inbound Resolver

- 3 VPCs (1 shared services, 2 application VPCs)
- Transit Gateway for connectivity
- Private Hosted Zone for cloud.example.com
- Route 53 Inbound Resolver in the shared services VPC
- Simulated on-premises DNS forwarding

Replace key name in `terraform.tfvars`

Run locally

```
terraform init
terraform apply -auto-approve
terraform output > lab_info.txt
```

SSH to AWS ec2 

`ssh -i ~/.ssh/<key-name>.perm ec2-user@<public-ip>` (find the public-ip in lab_info.txt)

run script

`./test_hybrid_dns.sh`

Finally

`terraform destroy`


