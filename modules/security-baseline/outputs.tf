output "account_id" {
  description = "AWS account where the security baseline is deployed"
  value       = data.aws_caller_identity.current.account_id
}

output "security_audit_role_arn" {
  description = "Cross-account security audit role ARN"
  value       = aws_iam_role.security_audit.arn
}

output "ebs_encryption_by_default_enabled" {
  description = "Whether EBS encryption by default is enabled"
  value       = aws_ebs_encryption_by_default.this.enabled
}   