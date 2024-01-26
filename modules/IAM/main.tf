################################################################################
# ECS IAM
################################################################################
resource "aws_iam_role_policy_attachment" "Cloudwatch_FullAccess" {
  role       = aws_iam_role.ecs_agent.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
}


resource "aws_iam_role" "ecs_agent" {
  name               = "agha_rameez-ecs-agent"
  assume_role_policy = data.aws_iam_policy_document.ecs_agent.json
}


resource "aws_iam_role_policy_attachment" "ecs_agent" {
  role       = aws_iam_role.ecs_agent.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
  depends_on = [aws_iam_role.ecs_agent]
}

resource "aws_iam_instance_profile" "ecs_agent" {
  name = "agha-rameez-ecs-agent"
  role = aws_iam_role.ecs_agent.name
}
################################################################################
# CodeBUILD IAM
################################################################################
resource "aws_iam_role" "codebuild" {
  name = "agharameez-codebuild-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "codebuild.amazonaws.com"
        }
      },
    ]
  })
}
resource "aws_iam_role_policy_attachment" "codebuild" {
  role = aws_iam_role.codebuild.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}
################################################################################
# CodePipeline IAM
################################################################################
resource "aws_iam_role" "codepipeline" {
  name = "agharameez-codepipeline-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "codebuild.amazonaws.com"
        }
      },
    ]
  })
}
resource "aws_iam_role_policy_attachment" "codepipeline" {
  role = aws_iam_role.codepipeline.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}