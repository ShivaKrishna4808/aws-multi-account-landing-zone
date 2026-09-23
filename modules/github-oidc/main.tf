data "aws_iam_openid_connect_provider" "github" {
  url = "https://token.actions.githubusercontent.com"
}

locals {
  github_pr_subject = "repo:${var.github_owner}@${var.github_owner_id}/${var.github_repository}@${var.github_repository_id}:pull_request"
}

data "aws_iam_policy_document" "github_actions_trust" {
  statement {
    effect = "Allow"

    actions = [
      "sts:AssumeRoleWithWebIdentity"
    ]

    principals {
      type = "Federated"

      identifiers = [
        data.aws_iam_openid_connect_provider.github.arn
      ]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"

      values = [
        "sts.amazonaws.com"
      ]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:sub"

      values = [
        local.github_pr_subject
      ]
    }
  }
}

resource "aws_iam_role" "github_actions_plan" {
  name = "LandingZoneGitHubActionsPlanRole"

  assume_role_policy = data.aws_iam_policy_document.github_actions_trust.json

  max_session_duration = 3600

  tags = {
    Project   = "aws-multi-account-landing-zone"
    ManagedBy = "Terraform"
    Purpose   = "GitHubActionsTerraformPlan"
  }
}

data "aws_iam_policy_document" "github_actions_permissions" {

  statement {
    sid    = "ReadTerraformStateBucket"
    effect = "Allow"

    actions = [
      "s3:ListBucket",
      "s3:GetBucketLocation"
    ]

    resources = [
      "arn:aws:s3:::${var.terraform_state_bucket}"
    ]
  }

  statement {
    sid    = "ManageTerraformStateObjects"
    effect = "Allow"

    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject"
    ]

    resources = [
      "arn:aws:s3:::${var.terraform_state_bucket}/*"
    ]
  }

  statement {
    sid    = "AssumeSandboxTerraformRole"
    effect = "Allow"

    actions = [
      "sts:AssumeRole"
    ]

    resources = [
      "arn:aws:iam::${var.sandbox_account_id}:role/OrganizationAccountAccessRole"
    ]
  }
}

resource "aws_iam_role_policy" "github_actions_plan" {
  name = "LandingZoneGitHubActionsPlanPolicy"
  role = aws_iam_role.github_actions_plan.id

  policy = data.aws_iam_policy_document.github_actions_permissions.json
}