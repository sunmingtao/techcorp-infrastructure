terraform {
    required_providers {
      aws = {
        source  = "hashicorp/aws"
        version = "~> 5.0"
      }
    }
  }

  provider "aws" {
    region = var.aws_region
  }

  # VPC
  resource "aws_vpc" "techcorp_vpc" {
    cidr_block           = "10.2.0.0/16"
    enable_dns_hostnames = true
    enable_dns_support   = true
    
    tags = {
      Name = "techcorp-vpc"
    }
  }

  # Internet Gateway
  resource "aws_internet_gateway" "techcorp_igw" {
    vpc_id = aws_vpc.techcorp_vpc.id
    
    tags = {
      Name = "techcorp-igw"
    }
  }

  # Public Subnet
  resource "aws_subnet" "public_subnet" {
    vpc_id                  = aws_vpc.techcorp_vpc.id
    cidr_block              = "10.2.1.0/24"
    availability_zone       = "${var.aws_region}a"
    map_public_ip_on_launch = true
    
    tags = {
      Name = "techcorp-public-subnet"
    }
  }

  # Private Subnet
  resource "aws_subnet" "private_subnet" {
    vpc_id            = aws_vpc.techcorp_vpc.id
    cidr_block        = "10.2.2.0/24"
    availability_zone = "${var.aws_region}a"
    
    tags = {
      Name = "techcorp-private-subnet"
    }
  }

  # Route Table for Public Subnet
  resource "aws_route_table" "public_rt" {
    vpc_id = aws_vpc.techcorp_vpc.id
    
    route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.techcorp_igw.id
    }

    tags = {
      Name = "techcorp-public-rt"
    }
  }

  resource "aws_route_table_association" "public_rta" {
    subnet_id      = aws_subnet.public_subnet.id
    route_table_id = aws_route_table.public_rt.id
  }