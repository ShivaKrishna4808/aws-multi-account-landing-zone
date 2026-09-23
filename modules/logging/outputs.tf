output "trail_name" {
  description = "Organization CloudTrail trail name"
  value       = aws_cloudtrail.organization.name
}

output "trail_arn" {
  description = "Organization CloudTrail trail ARN"
  value       = aws_cloudtrail.organization.arn
}

output "audit_bucket_name" {
  description = "Centralized CloudTrail audit bucket"
  value       = aws_s3_bucket.audit_logs.bucket
}

output "audit_bucket_arn" {
  description = "Centralized CloudTrail audit bucket ARN"
  value       = aws_s3_bucket.audit_logs.arn
}