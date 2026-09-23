output "account_id" {
  description = "AWS member account ID"
  value       = aws_organizations_account.this.id
}

output "account_arn" {
  description = "AWS member account ARN"
  value       = aws_organizations_account.this.arn
}

output "account_name" {
  description = "AWS member account name"
  value       = aws_organizations_account.this.name
}