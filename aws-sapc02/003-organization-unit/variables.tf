variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "attach_restrictive_to_root" {
  description = "Whether to attach restrictive policy to root (simulates initial problem state)"
  type        = bool
  default     = true
}

variable "organization_name" {
  description = "Name for the organization"
  type        = string
  default     = "Lab Organization"
}
