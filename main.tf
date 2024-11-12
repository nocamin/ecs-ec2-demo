module "networking" {
  source = "./modules/networking"
  providers = {
    aws = aws
  }
}

module "ecs_cluster_primary" {
  source    = "./modules/ecs_cluster"
  providers = { aws = aws.primary }
}

module "ecs_cluster_secondary" {
  source    = "./modules/ecs_cluster"
  providers = { aws = aws.secondary }
}

module "global_s3" {
  source = "./global/s3"
  providers = { aws = aws }
}
