variable "icinga_cctld_au_epp_user" {
  description = "The Icinga Testing CCTLD.AU EPP Username"
  type        = string
}

variable "icinga_cctld_au_epp_password" {
  description = "The Icinga Testing CCTLD.AU EPP Password"
  type        = string
  sensitive   = true
}

variable "vpc_id" {
  description = "ID of the VPC to associate with ECS resources"
  type        = string
}

variable "s3_bucket_nocping" {
  description = "S3 bucket name for nocping certs"
  type        = string
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
