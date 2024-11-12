module "networking" {
  source = "./modules/networking"
  providers = {
    aws = aws
  }
}

module "ecs_cluster_primary" {
  source    = "./modules/ecs_cluster"
  providers = { aws = aws.us-east-1 }
}

module "ecs_cluster_secondary" {
  source    = "./modules/ecs_cluster"
  providers = { aws = aws.us-west-2 }
}

module "global_s3" {
  source = "./global/s3"
  providers = { aws = aws }
}
