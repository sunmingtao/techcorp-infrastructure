# AWS Cross-Region Failover Lab
# This lab demonstrates the weather API scenario with Route 53 failover routing

# Variables
variable "primary_region" {
  description = "Primary AWS region"
  type        = string
  default     = "us-east-1"
}

variable "secondary_region" {
  description = "Secondary AWS region for failover"
  type        = string
  default     = "us-west-2"
}

variable "project_name" {
  description = "Project name for resource naming"
  type        = string
  default     = "weather-api-lab"
}

# Provider configurations for multi-region deployment
provider "aws" {
  alias  = "primary"
  region = var.primary_region
}

provider "aws" {
  alias  = "secondary"
  region = var.secondary_region
}

# Data sources
data "aws_caller_identity" "current" {}
data "aws_region" "primary" {
  provider = aws.primary
}
data "aws_region" "secondary" {
  provider = aws.secondary
}
