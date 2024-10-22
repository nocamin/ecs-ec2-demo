variable "icinga_cctld_au_epp_user" {
  description = "The Icinga Testing CCTLD.AU EPP Username"
  type        = string
}

variable "icinga_cctld_au_epp_password" {
  description = "The Icinga Testing CCTLD.AU EPP Password"
  type        = string
  sensitive   = true
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

variable "environment" {
  description = "Environment name."
  type        = string
  default     = "dev"
}