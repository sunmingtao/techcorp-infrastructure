# ============================================================================
# ROUTE TABLES FOR TRANSIT GATEWAY COMMUNICATION
# ============================================================================

# Update VPC route tables to point to Transit Gateway for cross-VPC communication
resource "aws_route_table" "shared_private_rt" {
  vpc_id = aws_vpc.shared_services.id

  route {
    cidr_block         = "10.4.0.0/16"
    transit_gateway_id = aws_ec2_transit_gateway.main.id
  }

  route {
    cidr_block         = "10.5.0.0/16"
    transit_gateway_id = aws_ec2_transit_gateway.main.id
  }

  tags = {
    Name    = "${var.project_name}-shared-private-rt"
    Project = var.project_name
  }

  depends_on = [aws_ec2_transit_gateway_vpc_attachment.shared_services]
}

resource "aws_route_table_association" "shared_private_1a" {
  subnet_id      = aws_subnet.shared_private_1a.id
  route_table_id = aws_route_table.shared_private_rt.id
}

resource "aws_route_table_association" "shared_private_1b" {
  subnet_id      = aws_subnet.shared_private_1b.id
  route_table_id = aws_route_table.shared_private_rt.id
}

resource "aws_route_table" "app_a_private_rt" {
  vpc_id = aws_vpc.app_a.id

  route {
    cidr_block         = "10.3.0.0/16"
    transit_gateway_id = aws_ec2_transit_gateway.main.id
  }

  route {
    cidr_block         = "10.5.0.0/16"
    transit_gateway_id = aws_ec2_transit_gateway.main.id
  }

  tags = {
    Name    = "${var.project_name}-app-a-private-rt"
    Project = var.project_name
  }

  depends_on = [aws_ec2_transit_gateway_vpc_attachment.app_a]
}

resource "aws_route_table_association" "app_a_private" {
  subnet_id      = aws_subnet.app_a_private.id
  route_table_id = aws_route_table.app_a_private_rt.id
}

resource "aws_route_table" "app_b_private_rt" {
  vpc_id = aws_vpc.app_b.id

  route {
    cidr_block         = "10.3.0.0/16"
    transit_gateway_id = aws_ec2_transit_gateway.main.id
  }

  route {
    cidr_block         = "10.4.0.0/16"
    transit_gateway_id = aws_ec2_transit_gateway.main.id
  }

  tags = {
    Name    = "${var.project_name}-app-b-private-rt"
    Project = var.project_name
  }

  depends_on = [aws_ec2_transit_gateway_vpc_attachment.app_b]
}

resource "aws_route_table_association" "app_b_private" {
  subnet_id      = aws_subnet.app_b_private.id
  route_table_id = aws_route_table.app_b_private_rt.id
}

