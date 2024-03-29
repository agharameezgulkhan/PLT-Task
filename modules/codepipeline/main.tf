
resource "aws_codestarconnections_connection" "this" {
  name          = "Agha-connection"
  provider_type = "GitHub"
}



################################################################################
# CodePipeline
################################################################################

resource "aws_codepipeline" "this" {

  name     = "agharameez-codepipeline"
  role_arn = aws_iam_role.codepipeline.arn

  artifact_store {

    location = var.s3_bucket_id
    type     = "S3"

    encryption_key {
      id   = data.aws_kms_alias.s3kmskey.id
      type = "KMS"
    }
  }

  stage {
    name = "Source"
    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      run_order        = 1
      output_artifacts = ["source_output"]
      configuration = {
        ConnectionArn       = aws_codestarconnections_connection.this.arn
        FullRepositoryId = "agharameezgulkhan/PLT-Task"
        BranchName           = "master"
      }
    }
  }

  # stage {
  #   name = "TerraformValidate"
  #   action {
  #     name             = "Validate"
  #     category         = "Build"
  #     owner            = "AWS"
  #     provider         = "CodeBuild"
  #     version          = "1"
  #     run_order        = 2
  #     input_artifacts  = ["SOURCE_ARTIFACT"]
  #     output_artifacts = ["VALIDATE_ARTIFACT"]
  #     configuration = {
  #       ProjectName = aws_codebuild_project.this.name
  #       EnvironmentVariables = jsonencode([
  #         {
  #           name  = "ACTION"
  #           value = "VALIDATE"
  #           type  = "PLAINTEXT"
  #         }
  #       ])
  #     }
  #   }
  # }

  stage {
    name = "TerraformPlan"
    action {
      name             = "Plan"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      version          = "1"
      run_order        = 2
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output"]
      configuration = {
        ProjectName = var.aws_codebuild_project_name
        # EnvironmentVariables = jsonencode([
        #   {
        #     name  = "ACTION"
        #     value = "PLAN"
        #     type  = "PLAINTEXT"
        #   }
        # ])
      }
    }
  }

  # stage {
  #   name = "ApprovalApply"
  #   action {
  #     name      = "Apply"
  #     category  = "Approval"
  #     owner     = "AWS"
  #     provider  = "Manual"
  #     version   = "1"
  #     run_order = 3
  #     configuration = {
  #       NotificationArn = aws_sns_topic.this.arn
  #     }
  #   }
  # }

  # stage {
  #   name = "TerraformApply"
  #   action {
  #     name             = "Apply"
  #     category         = "Build"
  #     owner            = "AWS"
  #     provider         = "CodeBuild"
  #     version          = "1"
  #     run_order        = 4
  #     input_artifacts  = ["PLAN_ARTIFACT"]
  #     output_artifacts = ["APPLY_ARTIFACT"]
  #     configuration = {
  #       ProjectName = aws_codebuild_project.this.name
  #       EnvironmentVariables = jsonencode([
  #         {
  #           name  = "ACTION"
  #           value = "APPLY"
  #           type  = "PLAINTEXT"
  #         }
  #       ])
  #     }
  #   }
  # }

  # stage {
  #   name = "ApprovalDestroy"
  #   action {
  #     name      = "Destroy"
  #     category  = "Approval"
  #     owner     = "AWS"
  #     provider  = "Manual"
  #     version   = "1"
  #     run_order = 5
  #     configuration = {
  #       NotificationArn = aws_sns_topic.this.arn
  #     }
  #   }
  # }

  # stage {
  #   name = "TerraformDestroy"
  #   action {
  #     name            = "Destroy"
  #     category        = "Build"
  #     owner           = "AWS"
  #     provider        = "CodeBuild"
  #     version         = "1"
  #     run_order       = 6
  #     input_artifacts = ["APPLY_ARTIFACT"]
  #     configuration = {
  #       ProjectName = aws_codebuild_project.this.name
  #       EnvironmentVariables = jsonencode([
  #         {
  #           name  = "ACTION"
  #           value = "DESTROY"
  #           type  = "PLAINTEXT"
  #         }
  #       ])
  #     }
  #   }
  # }
}


################################################################################
# IAM Role for CodePipeline
################################################################################

resource "aws_iam_role" "codepipeline" {
  name = "agharameez-codepipeline"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "codepipeline.amazonaws.com"
        }
      },
    ]
  })
}

data "aws_iam_policy_document" "codepipeline" {
  statement {
    sid = "s3access"
    actions = [
      "s3:GetObject",
      "s3:GetObjectVersion",
      "s3:GetBucketVersioning",
      "s3:PutObjectAcl",
      "s3:PutObject",
      "s3:ListBucket",
    ]

    resources = [var.s3_bucket_arn, "${var.s3_bucket_arn}/*"]
  }

  statement {
    sid = "codebuildaccess"
    actions = [
      "codebuild:BatchGetBuilds",
      "codebuild:StartBuild"
    ]
    resources = [var.aws_codebuild_project_name_arn]
  }
  statement {
    effect    = "Allow"
    actions   = ["codestar-connections:UseConnection"]
    resources = ["*"]
  }
  statement {
    sid = "kmsaccess"
    actions = [
      "kms:DescribeKey",
      "kms:GenerateDataKey*",
      "kms:Encrypt",
      "kms:ReEncrypt*",
      "kms:Decrypt"
    ]
    resources = [data.aws_kms_alias.s3kmskey.arn]
  }
}

resource "aws_iam_policy" "codepipeline" {
  name   = "agharameez-codepipeline"
  policy = data.aws_iam_policy_document.codepipeline.json
}

resource "aws_iam_role_policy_attachment" "codepipeline" {
  role       = aws_iam_role.codepipeline.name
  policy_arn = aws_iam_policy.codepipeline.arn
}