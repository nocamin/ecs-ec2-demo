module "ecs_us_east_1" {
  source        = "./modules/nocping_ecs"
  region        = "us-east-1"
  default_region = var.default_region
  icinga_cctld_au_epp_user    = var.icinga_cctld_au_epp_user
  icinga_cctld_au_epp_password = var.icinga_cctld_au_epp_password
  providers = {
    aws = aws.us-east-1
  }
}
