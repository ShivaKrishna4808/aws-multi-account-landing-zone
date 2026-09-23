output "github_oidc_provider_arn" {
  description = "Existing GitHub Actions OIDC provider ARN"
  value       = data.aws_iam_openid_connect_provider.github.arn
}

output "github_actions_role_arn" {
  description = "IAM role assumed by GitHub Actions"
  value       = aws_iam_role.github_actions_plan.arn
}

output "github_actions_role_name" {
  description = "IAM role assumed by GitHub Actions"
  value       = aws_iam_role.github_actions_plan.name
}