variable "aws_region" {
  description = "AWS account region."
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment name."
  type        = string
  default     = "prod"
}

variable "ecs_cluster_ami_name" {
  description = "AMI name for the ECS host."
  type        = string
}

