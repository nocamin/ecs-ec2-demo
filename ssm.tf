#locals {
#  constants_ssm_path = "/config/constants"
#}

resource "aws_ssm_parameter" "ecs_cluster_ami_name" {
# name    = "${local.constants_ssm_path}/ecs_cluster_ami_name"
  name    = "ecs_cluster_ami_name"
  type    = "SecureString"
  value   = var.ecs_cluster_ami_name
  tier    = "Standard"
}

