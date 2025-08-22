# ============================================================================
# TRANSIT GATEWAY
# ============================================================================

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
