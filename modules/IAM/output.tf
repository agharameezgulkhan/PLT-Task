output "iam_profile" {
  value = aws_iam_instance_profile.ecs_agent
}
output "aws_iam_role" {
  value = aws_iam_role.ecs_agent
}
output "codebuild_arn" {
  value = aws_iam_role.codebuild.arn
}

output "codepipeline_arn" {
  value = aws_iam_role.codepipeline.arn
}