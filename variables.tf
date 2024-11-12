variable "primary_region" {
  description = "Primary AWS region"
  default     = "us-east-1"
}

variable "secondary_region" {
  description = "Secondary AWS region"
  default     = "us-west-2"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "aws_account_id" {
  description = "AWS Account ID"
  type        = string
}


variable "aws_region" {
  description = "AWS region"
  type        = string
}

