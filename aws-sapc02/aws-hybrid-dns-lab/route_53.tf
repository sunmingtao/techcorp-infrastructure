# ============================================================================
# ROUTE 53 PRIVATE HOSTED ZONE
# ============================================================================

resource "aws_route53_zone" "private" {
  name = var.domain_name

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
  records = ["10.3.1.100"]
}

resource "aws_route53_record" "db" {
  zone_id = aws_route53_zone.private.zone_id
  name    = "db.${var.domain_name}"
  type    = "A"
  ttl     = 300
  records = ["10.3.1.200"]
}

resource "aws_route53_record" "web" {
  zone_id = aws_route53_zone.private.zone_id
  name    = "web.${var.domain_name}"
  type    = "A"
  ttl     = 300
  records = ["10.4.1.50"]
}
