provider "aws" {
  region = var.aws_region
}

resource "aws_organizations_organization" "main" {
  aws_service_access_principals = [
    "config.amazonaws.com",
    "cloudtrail.amazonaws.com",
  ]

  feature_set = "ALL"

  enabled_policy_types = [
    "SERVICE_CONTROL_POLICY",
  ]

}

# Create Organizational Units
resource "aws_organizations_organizational_unit" "production" {
  name      = "Production"
  parent_id = aws_organizations_organization.main.roots[0].id

  tags = {
    Environment = "Production"
    Purpose     = "Live workloads"
  }
}

resource "aws_organizations_organizational_unit" "development" {
  name      = "Development"
  parent_id = aws_organizations_organization.main.roots[0].id

  tags = {
    Environment = "Development"
    Purpose     = "Dev and test workloads"
  }
}

resource "aws_organizations_organizational_unit" "onboarding" {
  name      = "Onboarding"
  parent_id = aws_organizations_organization.main.roots[0].id

  tags = {
    Environment = "Temporary"
    Purpose     = "New account setup"
  }
}

# Create nested OUs for advanced practice
resource "aws_organizations_organizational_unit" "core" {
  name      = "Core"
  parent_id = aws_organizations_organization.main.roots[0].id

  tags = {
    Purpose = "Infrastructure accounts"
  }
}

resource "aws_organizations_organizational_unit" "security" {
  name      = "Security"
  parent_id = aws_organizations_organizational_unit.core.id

  tags = {
    Purpose = "Security and compliance"
  }
}

resource "aws_organizations_organizational_unit" "logging" {
  name      = "Logging"
  parent_id = aws_organizations_organizational_unit.core.id

  tags = {
    Purpose = "Centralized logging"
  }
}

resource "aws_organizations_policy" "restricted_services" {
  name        = "RestrictedServices"
  description = "Deny list policy simulating production restrictions"
  type        = "SERVICE_CONTROL_POLICY"

  content = file("${path.module}/policies/restricted-services.json")

  tags = {
    PolicyType = "Restrictive"
    Purpose    = "Production safety"
  }
}

resource "aws_organizations_policy_attachment" "restricted_to_root" {
  count     = var.attach_restrictive_to_root ? 1 : 0
  policy_id = aws_organizations_policy.restricted_services.id
  target_id = aws_organizations_organization.main.roots[0].id
}
