module "dynamic-vpc" {
  source        = "./modules/vpc"
  cidr_block    = var.cidr_block
  tags          = var.tags
  publicprefix  = var.publicprefix
  privateprefix = var.privateprefix
  nat_gateway   = var.nat_gateway
}
module "iam" {
  source = "./modules/IAM"
}
module "ecs_module" {
  source           = "./modules/ecs"
  cluster_name     = var.cluster_name
  aws_iam_role     = module.iam.aws_iam_role
  security-group   = module.dynamic-vpc.security-group
  public_subnet_id = module.dynamic-vpc.public_subnet_id
  private_subnet_id = module.dynamic-vpc.private_subnet_id
  vpc_id = module.dynamic-vpc.vpc_id
}

module "codebuild" {
  source = "./modules/codebuild"
  codebuild_arn = module.iam.codebuild_arn
}
