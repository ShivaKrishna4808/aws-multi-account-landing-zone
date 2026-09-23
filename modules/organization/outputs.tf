output "organization_id" {
  description = "ID of the AWS Organization"
  value       = aws_organizations_organization.this.id
}

output "organization_arn" {
  description = "ARN of the AWS Organization"
  value       = aws_organizations_organization.this.arn
}

output "management_account_id" {
  description = "AWS Organizations management account ID"
  value       = aws_organizations_organization.this.master_account_id
}

output "roots" {
  description = "AWS Organization root information"
  value       = aws_organizations_organization.this.roots
}

output "root_id" {
  description = "AWS Organizations root ID"
  value       = one(aws_organizations_organization.this.roots).id
}