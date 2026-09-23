data "aws_iam_openid_connect_provider" "github" {
  url = "https://token.actions.githubusercontent.com"
}

locals {
  github_pr_subject = "repo:${var.github_owner}@${var.github_owner_id}/${var.github_repository}@${var.github_repository_id}:pull_request"

  github_main_subject = "repo:${var.github_owner}@${var.github_owner_id}/${var.github_repository}@${var.github_repository_id}:ref:refs/heads/main"
}

# ============================================================
# GitHub Actions PLAN role
# Used only by Pull Requests
# ============================================================

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

# ============================================================
# GitHub Actions APPLY role
# Used only from main branch
# ============================================================

data "aws_iam_policy_document" "github_actions_apply_trust" {
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
        local.github_main_subject
      ]
    }
  }
}

resource "aws_iam_role" "github_actions_apply" {
  name = "LandingZoneGitHubActionsApplyRole"

  assume_role_policy = data.aws_iam_policy_document.github_actions_apply_trust.json

  max_session_duration = 3600

  tags = {
    Project   = "aws-multi-account-landing-zone"
    ManagedBy = "Terraform"
    Purpose   = "GitHubActionsAccountProvisioning"
  }
}

data "aws_iam_policy_document" "github_actions_apply_permissions" {
  statement {
    sid    = "TerraformStateBucket"
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
    sid    = "TerraformStateObjects"
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
    sid    = "AccountFactory"
    effect = "Allow"

    actions = [
      "organizations:CreateAccount",
      "organizations:DescribeAccount",
      "organizations:DescribeCreateAccountStatus",
      "organizations:DescribeOrganization",
      "organizations:ListAccounts",
      "organizations:ListAccountsForParent",
      "organizations:ListChildren",
      "organizations:ListOrganizationalUnitsForParent",
      "organizations:ListParents",
      "organizations:ListRoots",
      "organizations:ListTagsForResource",
      "organizations:MoveAccount",
      "organizations:TagResource",
      "organizations:UntagResource"
    ]

    resources = [
      "*"
    ]
  }
}

resource "aws_iam_role_policy" "github_actions_apply" {
  name = "LandingZoneGitHubActionsApplyPolicy"
  role = aws_iam_role.github_actions_apply.id

  policy = data.aws_iam_policy_document.github_actions_apply_permissions.json
}