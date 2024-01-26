resource "aws_s3_bucket" "codepipeline_bucket" {
  bucket = "Eurus-ui-codepipeline-bucket"
  force_destroy = true
}

resource "aws_s3_bucket_ownership_controls" "code_pipeline_controls" {
  bucket = aws_s3_bucket.codepipeline_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}