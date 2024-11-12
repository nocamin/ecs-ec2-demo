module "vpc" {
  source = "./modules/vpc"
  providers = {
    aws = aws
  }
}

module "ecs_cluster_us_east_1" {
  source    = "./modules/ecs_cluster"
  vpc_id                          = aws_vpc.main.id
  s3_bucket_nocping               = aws_s3_bucket.nocping.bucket
  icinga_cctld_au_epp_user        = var.icinga_cctld_au_epp_user
  icinga_cctld_au_epp_password    = var.icinga_cctld_au_epp_password
  
  providers = { aws = aws.us-east-1 }
}

module "ecs_cluster_us_west_2" {
  source    = "./modules/ecs_cluster"
  vpc_id                         = aws_vpc.main.id
  s3_bucket_nocping              = aws_s3_bucket.nocping.bucket
  icinga_cctld_au_epp_user       = var.icinga_cctld_au_epp_user
  icinga_cctld_au_epp_password   = var.icinga_cctld_au_epp_password

  providers = { aws = aws.us-west-2 }
}

module "global_s3" {
  source = "./modules/global/s3"
  providers = { aws = aws }
}
