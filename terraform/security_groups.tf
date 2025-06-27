resource "aws_security_group" "frontend_sg" {
    name_prefix = "techcorp-frontend-"
    vpc_id      = aws_vpc.techcorp_vpc.id

    ingress {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "SSH from my IP"
    }

    # HTTP from anywhere
    ingress {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "HTTP from anywhere"
    }

    # HTTPS from anywhere
    ingress {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "HTTPS from anywhere"
    }

    # Squid proxy from internal subnet
    ingress {
      from_port   = 3128
      to_port     = 3128
      protocol    = "tcp"
      cidr_blocks = ["10.2.0.0/16"]
      description = "Squid proxy from internal subnet"
    }

    # ICMP from internal subnet
    ingress {
      from_port   = -1
      to_port     = -1
      protocol    = "icmp"
      cidr_blocks = ["10.2.0.0/16"]
      description = "ICMP from internal subnet"
    }

    egress {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow all outbound"
    }

    tags = {
      Name = "techcorp-frontend-sg"
    }
  }

  resource "aws_security_group" "internal_sg" {
    name_prefix = "techcorp-internal-"
    vpc_id      = aws_vpc.techcorp_vpc.id
   
    # SSH only from frontend security group (bastion)
    ingress {
      from_port       = 22
      to_port         = 22
      protocol        = "tcp"
      security_groups = [aws_security_group.frontend_sg.id]
      description     = "SSH from frontend bastion only"
    }

    # All internal VPC traffic
    ingress {
      from_port   = 0
      to_port     = 65535
      protocol    = "tcp"
      cidr_blocks = ["10.2.0.0/16"]
      description = "All TCP traffic within VPC"
    }

    # ICMP for ping
    ingress {
      from_port   = -1
      to_port     = -1
      protocol    = "icmp"
      cidr_blocks = ["10.2.0.0/16"]
      description = "ICMP within VPC"
    }

    egress {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow all outbound"
    }

     tags = {
      Name = "techcorp-internal-sg"
    }
  }