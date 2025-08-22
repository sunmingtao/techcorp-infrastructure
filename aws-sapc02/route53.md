```
resource "aws_route53_zone" "private" {
  name = var.domain_name # cloud.example.com

  vpc {
    vpc_id = aws_vpc.shared_services.id
  }

  vpc {
    vpc_id = aws_vpc.app_a.id
  }

  vpc {
    vpc_id = aws_vpc.app_b.id
  }

  tags = {
    Name    = "${var.project_name}-private-zone"
    Project = var.project_name
  }
}

# DNS Records
resource "aws_route53_record" "api" {
  zone_id = aws_route53_zone.private.zone_id
  name    = "api.${var.domain_name}"
  type    = "A"
  ttl     = 300
  records = ["10.0.1.100"]
}

resource "aws_route53_record" "db" {
  zone_id = aws_route53_zone.private.zone_id
  name    = "db.${var.domain_name}"
  type    = "A"
  ttl     = 300
  records = ["10.0.1.200"]
}

resource "aws_route53_record" "web" {
  zone_id = aws_route53_zone.private.zone_id
  name    = "web.${var.domain_name}"
  type    = "A"
  ttl     = 300
  records = ["10.1.1.50"]
}

# At this point, the EC2 instances on these VPCs can resolve cloud.example.com
# But not from the public IP, until the inbount route 53 endpoint is configured. 

# Security group for Route 53 Resolver endpoints
resource "aws_security_group" "resolver_sg" {
  name_prefix = "${var.project_name}-resolver-sg"
  description = "Security group for Route 53 Resolver endpoints"
  vpc_id      = aws_vpc.shared_services.id

  # Allow DNS queries from all VPC CIDRs
  ingress {
    description = "DNS TCP from VPCs"
    from_port   = 53
    to_port     = 53
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8"]
  }

  ingress {
    description = "DNS UDP from VPCs"
    from_port   = 53
    to_port     = 53
    protocol    = "udp"
    cidr_blocks = ["10.0.0.0/8"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "${var.project_name}-resolver-sg"
    Project = var.project_name
  }
}

resource "aws_route53_resolver_endpoint" "inbound" {
  name      = "${var.project_name}-inbound-resolver"
  direction = "INBOUND"

  security_group_ids = [aws_security_group.resolver_sg.id]

  ip_address {
    subnet_id = aws_subnet.shared_private_1a.id
  }

  ip_address {
    subnet_id = aws_subnet.shared_private_1b.id
  }

  tags = {
    Name    = "${var.project_name}-inbound-resolver"
    Project = var.project_name
  }
}
```


