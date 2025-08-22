# ============================================================================
# SUBNETS
# ============================================================================

# Shared Services VPC Subnets
resource "aws_subnet" "shared_private_1a" {
  vpc_id            = aws_vpc.shared_services.id
  cidr_block        = "10.3.1.0/24"
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name    = "${var.project_name}-shared-private-1a"
    Project = var.project_name
  }
}

resource "aws_subnet" "shared_private_1b" {
  vpc_id            = aws_vpc.shared_services.id
  cidr_block        = "10.3.2.0/24"
  availability_zone = data.aws_availability_zones.available.names[1]

  tags = {
    Name    = "${var.project_name}-shared-private-1b"
    Project = var.project_name
  }
}

# App VPC A Subnets
resource "aws_subnet" "app_a_private" {
  vpc_id            = aws_vpc.app_a.id
  cidr_block        = "10.4.1.0/24"
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name    = "${var.project_name}-app-a-private"
    Project = var.project_name
  }
}

resource "aws_subnet" "app_a_public" {
  vpc_id                  = aws_vpc.app_a.id
  cidr_block              = "10.4.100.0/24"
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name    = "${var.project_name}-app-a-public"
    Project = var.project_name
  }
}

# App VPC B Subnets
resource "aws_subnet" "app_b_private" {
  vpc_id            = aws_vpc.app_b.id
  cidr_block        = "10.5.1.0/24"
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name    = "${var.project_name}-app-b-private"
    Project = var.project_name
  }
}
