output "code_pipeline_bucket" {
  value = aws_s3_bucket.codepipeline_bucket.id
}

output "code_pipeline_bucket_arn" {
  value = aws_s3_bucket.codepipeline_bucket.arn
}