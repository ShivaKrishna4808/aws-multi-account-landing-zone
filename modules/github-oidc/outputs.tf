output "github_oidc_provider_arn" {
  description = "Existing GitHub Actions OIDC provider ARN"
  value       = data.aws_iam_openid_connect_provider.github.arn
}

output "github_actions_role_arn" {
  description = "IAM role assumed by GitHub Actions for Terraform plans"
  value       = aws_iam_role.github_actions_plan.arn
}

output "github_actions_role_name" {
  description = "IAM role assumed by GitHub Actions for Terraform plans"
  value       = aws_iam_role.github_actions_plan.name
}

output "github_actions_apply_role_arn" {
  description = "IAM role used by GitHub Actions for controlled account provisioning"
  value       = aws_iam_role.github_actions_apply.arn
}

output "github_actions_apply_role_name" {
  description = "IAM role name used by GitHub Actions for controlled account provisioning"
  value       = aws_iam_role.github_actions_apply.name
}