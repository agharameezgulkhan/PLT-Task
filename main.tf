module "dynamic-vpc" {
  count = var.deploy_cluster == true? 1: 0
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
  count = var.deploy_cluster == true? 1: 0
  source            = "./modules/ecs"
  cluster_name      = var.cluster_name
  aws_iam_role      = module.iam.aws_iam_role
  security_group    = module.dynamic-vpc[0].security_group_id
  public_subnet_id  = module.dynamic-vpc[0].public_subnet_id
  vpc_id            = module.dynamic-vpc[0].vpc_id
}

module "s3" {
  count = var.deploy_cluster == true? 0: 1
  source = "./modules/s3"
}

module "codebuild" {
  count = var.deploy_cluster == true? 0: 1
  source        = "./modules/codebuild"
  codebuild_arn = module.iam.codebuild_arn
}

module "codepipeline" {
  count = var.deploy_cluster == true? 0: 1
  source = "./modules/codepipeline"
  codepipeline_role_arn = module.iam.codepipeline_arn
  s3_bucket_id = module.s3[0].code_pipeline_bucket
  s3_bucket_arn = module.s3[0].code_pipeline_bucket_arn
  aws_codebuild_project_name = module.codebuild[0].aws_codebuild_project_name
  aws_codebuild_project_name_arn = module.codebuild[0].aws_codebuild_project_name_arn
}
