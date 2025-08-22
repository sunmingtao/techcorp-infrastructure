# ============================================================================
# VPCs
# ============================================================================

# Shared Services VPC
resource "aws_vpc" "shared_services" {
  cidr_block           = "10.3.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name    = "${var.project_name}-shared-services-vpc"
    Project = var.project_name
  }
}

# Application VPC A
resource "aws_vpc" "app_a" {
  cidr_block           = "10.4.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name    = "${var.project_name}-app-a-vpc"
    Project = var.project_name
  }
	}

# Application VPC B
resource "aws_vpc" "app_b" {
  cidr_block           = "10.5.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name    = "${var.project_name}-app-b-vpc"
    Project = var.project_name
  }
}
