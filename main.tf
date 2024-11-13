module "ecs_cluster_us_east_1" {
  source                          = "./modules/ecs_cluster"
  icinga_cctld_au_epp_user        = var.icinga_cctld_au_epp_user
  icinga_cctld_au_epp_password    = var.icinga_cctld_au_epp_password
  bucket_region                   = var.bucket_region
  providers = {
    aws = aws.us_east_1
  }
}

module "ecs_cluster_us_west_2" {
  source                         = "./modules/ecs_cluster"
  icinga_cctld_au_epp_user       = var.icinga_cctld_au_epp_user
  icinga_cctld_au_epp_password   = var.icinga_cctld_au_epp_password
  providers = {
    aws = aws.us_west_2
  }
}


