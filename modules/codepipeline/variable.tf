variable "s3_bucket_name" {
  description = "S3 bucket name to be used for storing the artifacts"
  type        = string
}

variable "codepipeline_role_arn" {
  description = "ARN of the codepipeline IAM role"
  type        = string
}
