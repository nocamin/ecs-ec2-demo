module "ecs_cluster_us_east_1" {
  source                          = "./modules/ecs_cluster"
  region                          = "us-east-1"
  icinga_cctld_au_epp_user        = var.icinga_cctld_au_epp_user
  icinga_cctld_au_epp_password    = var.icinga_cctld_au_epp_password
  providers = {
    aws = aws.us-east-1
  }
}

module "ecs_cluster_us_west_2" {
  source                         = "./modules/ecs_cluster"
  region                         = "us-west-2"
  icinga_cctld_au_epp_user       = var.icinga_cctld_au_epp_user
  icinga_cctld_au_epp_password   = var.icinga_cctld_au_epp_password
  providers = {
    aws = aws.us-west-2
  }
}


