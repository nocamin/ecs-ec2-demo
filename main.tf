variable "regions" {
  type    = list(string)
  default = ["us-east-1", "us-east-2", "us-west-1", "us-west-2", "eu-west-1", "ap-southeast-1", "ap-northeast-1"]
}


module "ecs_cluster" {

  #for_each = { for region in var.regions : region => region }

  source = "./modules/nocping_ecs"

  aws_account_id  = var.aws_account_id
  aws_region       = each.key
  environment      = var.environment
  icinga_cctld_au_epp_user    = var.icinga_cctld_au_epp_user
  icinga_cctld_au_epp_password = var.icinga_cctld_au_epp_password
}
