variable "aws_region" {
  description = "AWS region for resources"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project name for resource tagging"
  type        = string
  default     = "hybrid-dns-lab"
}

variable "domain_name" {
  description = "Domain name for private hosted zone"
  type        = string
  default     = "cloud.example.com"
}

variable "key_pair_name" {
  description = "EC2 Key Pair name for instances (must exist in your account)"
  type        = string
  default     = ""  # Leave empty to create instances without key pair
}
