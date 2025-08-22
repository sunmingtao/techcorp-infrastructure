# ============================================================================
# ROUTE 53 RESOLVER INBOUND ENDPOINT
# ============================================================================

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
