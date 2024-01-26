variable "s3_bucket_id" {
  description = "S3 bucket name to be used for storing the artifacts"
  type        = string
}
variable "s3_bucket_arn" {
  type = string
}

variable "codepipeline_role_arn" {
  description = "ARN of the codepipeline IAM role"
  type        = string
}
variable "aws_codebuild_project_name" {
  type = string
}
variable "aws_codebuild_project_name_arn" {
  type = string
}