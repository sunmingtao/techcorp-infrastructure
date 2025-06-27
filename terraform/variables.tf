variable "aws_region"  {
  description = "AWS Region"
  type = string
  default = "us-east-1"
}

variable "key_pair_name"  {
  description = "AWS Key pair name"
  type = string
}

variable "my_ip"  {
  description = "Your public IP for SSH access"
  type = string
}

