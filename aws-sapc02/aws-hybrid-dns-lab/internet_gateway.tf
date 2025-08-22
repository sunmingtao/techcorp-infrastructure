# ============================================================================
# INTERNET GATEWAY & NAT GATEWAY (for public subnet access)
# ============================================================================

resource "aws_internet_gateway" "app_a_igw" {
  vpc_id = aws_vpc.app_a.id

  tags = {
    Name    = "${var.project_name}-app-a-igw"
    Project = var.project_name
  }
}

resource "aws_route_table" "app_a_public_rt" {
  vpc_id = aws_vpc.app_a.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.app_a_igw.id
  }

  route {
    cidr_block         = "10.3.0.0/16"  # To Shared Services VPC
    transit_gateway_id = aws_ec2_transit_gateway.main.id
  }

  route {
    cidr_block         = "10.5.0.0/16"  # To App VPC B
    transit_gateway_id = aws_ec2_transit_gateway.main.id
  }
  tags = {
    Name    = "${var.project_name}-app-a-public-rt"
    Project = var.project_name
  }

	depends_on = [aws_ec2_transit_gateway_vpc_attachment.app_a]
}

resource "aws_route_table_association" "app_a_public" {
  subnet_id      = aws_subnet.app_a_public.id
  route_table_id = aws_route_table.app_a_public_rt.id
}
