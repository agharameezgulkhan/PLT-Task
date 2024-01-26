################################################################################
# CodeBuild Project
################################################################################

resource "aws_codebuild_project" "this" {
  name                   = "agharameez-codebuild"
  service_role           = var.codebuild_arn
  concurrent_build_limit = 1

  environment {
    type                        = "LINUX_CONTAINER"
    image                       = "aws/codebuild/amazonlinux2-x86_64-standard:4.0"
    compute_type                = "BUILD_GENERAL1_SMALL"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = true
  }

  artifacts {
    type = "CODEPIPELINE"
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = "./modules/templates/buildspec.yaml"
  }

  logs_config {
    cloudwatch_logs {
      group_name = aws_cloudwatch_log_group.this.name
      status     = "ENABLED"
    }
  }
}


################################################################################
# Cloudwatch Log Group
################################################################################

resource "aws_cloudwatch_log_group" "this" {
  name = "/aws/codebuild/agharameez-codebuild"

  retention_in_days = 30
}
