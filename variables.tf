variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "aws_account_id" {
  type        = string
  description = "AWS account id"
  default     = "147997118683"
}

variable "aws_region" {
  description = "AWS account region."
  type        = string
  default     = "us-east-1"
}


