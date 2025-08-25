1 VPC has multiple subnets

1 VPC has 1 Internet gateway. 1 Internet gateway has 1 VPC. 

1 transit gateway can be attached to multiple VPCs. 

**1 VPC can only have a transit gateway??**

1 subnet can have only 1 route table

#### Terraform creates a transit gateway attached to 3 VPCs, also specifying the subnets
```
resource "aws_ec2_transit_gateway" "main" {
  description                     = "Transit Gateway for Hybrid DNS Lab"
  default_route_table_association = "enable"
  default_route_table_propagation = "enable"
  dns_support                     = "enable"

  tags = {
    Name    = "${var.project_name}-tgw"
    Project = var.project_name
  }
}

# TGW VPC Attachments
resource "aws_ec2_transit_gateway_vpc_attachment" "shared_services" {
  subnet_ids         = [aws_subnet.shared_private_1a.id, aws_subnet.shared_private_1b.id]
  transit_gateway_id = aws_ec2_transit_gateway.main.id
  vpc_id             = aws_vpc.shared_services.id

  tags = {
    Name    = "${var.project_name}-tgw-attachment-shared"
    Project = var.project_name
  }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "app_a" {
  subnet_ids         = [aws_subnet.app_a_private.id]
  transit_gateway_id = aws_ec2_transit_gateway.main.id
  vpc_id             = aws_vpc.app_a.id

  tags = {
    Name    = "${var.project_name}-tgw-attachment-app-a"
    Project = var.project_name
  }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "app_b" {
  subnet_ids         = [aws_subnet.app_b_private.id]
  transit_gateway_id = aws_ec2_transit_gateway.main.id
  vpc_id             = aws_vpc.app_b.id

  tags = {
    Name    = "${var.project_name}-tgw-attachment-app-b"
    Project = var.project_name
  }
}
```

#### Terraform code to create a route table (only specify the VPC, not specify the subnet net
```
resource "aws_route_table" "app_b_private_rt" {
  vpc_id = aws_vpc.app_b.id # attach to vpc

  # route to VPC (10.0.0.0/16) through transit gateway
  route {
    cidr_block         = "10.0.0.0/16"
    transit_gateway_id = aws_ec2_transit_gateway.main.id
  }

  # route to another VPC (10.1.0.0/16) through transit gateway
  route {
    cidr_block         = "10.1.0.0/16"
    transit_gateway_id = aws_ec2_transit_gateway.main.id
  }

  tags = {
    Name    = "${var.project_name}-app-b-private-rt"
    Project = var.project_name
  }

  depends_on = [aws_ec2_transit_gateway_vpc_attachment.app_b]
}
```

#### now associate the route table to subnet
```
resource "aws_route_table_association" "app_b_private" {
  subnet_id      = aws_subnet.app_b_private.id
  route_table_id = aws_route_table.app_b_private_rt.id
}
```

1 route table can be associated to multiple subnet

1 route53 can be attached to multiple VPCs

1 security group can only belong to 1 VPC

dynamodb, gateway api, and lambda function are all region specific.

lambda@Edge is global at CloudFront level. 

S3 is global. 

Organization root account is not restricted by any SCPs (Service Control Policies)
