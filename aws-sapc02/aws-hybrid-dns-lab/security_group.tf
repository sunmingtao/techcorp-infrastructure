# ============================================================================
# SECURITY GROUPS
# ============================================================================

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

# Security group for EC2 instances
resource "aws_security_group" "instance_sg" {
  name_prefix = "${var.project_name}-instance-sg"
  description = "Security group for test instances"
  vpc_id      = aws_vpc.app_a.id

  # SSH access (only if key pair is provided)
  dynamic "ingress" {
    for_each = var.key_pair_name != "" ? [1] : []
    content {
      description = "SSH"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  # Allow all traffic from VPC CIDRs
  ingress {
    description = "All traffic from VPCs"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.0.0.0/8"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "${var.project_name}-instance-sg"
    Project = var.project_name
  }
}

# Security groups for other VPCs
resource "aws_security_group" "shared_instance_sg" {
  name_prefix = "${var.project_name}-shared-instance-sg"
  description = "Security group for shared services instances"
  vpc_id      = aws_vpc.shared_services.id

  ingress {
    description = "All traffic from VPCs"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.0.0.0/8"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "${var.project_name}-shared-instance-sg"
    Project = var.project_name
  }
}

resource "aws_security_group" "app_b_instance_sg" {
  name_prefix = "${var.project_name}-app-b-instance-sg"
  description = "Security group for App B instances"
  vpc_id      = aws_vpc.app_b.id

  ingress {
    description = "All traffic from VPCs"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.0.0.0/8"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "${var.project_name}-app-b-instance-sg"
    Project = var.project_name
  }
}
