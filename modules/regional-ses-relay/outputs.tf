output "s3_bucket_id" {
  description = "ID of the S3 bucket used for emails"
  value       = module.ses.s3_bucket_id
}
