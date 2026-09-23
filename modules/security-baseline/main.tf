data "aws_caller_identity" "current" {}

resource "terraform_data" "account_guard" {
  lifecycle {
    precondition {
      condition     = data.aws_caller_identity.current.account_id == var.expected_account_id
      error_message = "Safety check failed: security baseline is running against the wrong AWS account."
    }
  }
}

resource "aws_s3_account_public_access_block" "this" {
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  depends_on = [
    terraform_data.account_guard
  ]
}

resource "aws_ebs_encryption_by_default" "this" {
  enabled = true

  depends_on = [
    terraform_data.account_guard
  ]
}

resource "aws_iam_account_password_policy" "this" {
  minimum_password_length        = 14
  require_lowercase_characters   = true
  require_uppercase_characters   = true
  require_numbers                = true
  require_symbols                = true
  allow_users_to_change_password = true
  max_password_age               = 90
  password_reuse_prevention      = 24
  hard_expiry                    = false

  depends_on = [
    terraform_data.account_guard
  ]
}

data "aws_iam_policy_document" "security_audit_trust" {
  statement {
    effect = "Allow"

    actions = [
      "sts:AssumeRole"
    ]

    principals {
      type = "AWS"

      identifiers = [
        "arn:aws:iam::${var.management_account_id}:root"
      ]
    }
  }
}

resource "aws_iam_role" "security_audit" {
  name = "LandingZoneSecurityAuditRole"

  assume_role_policy   = data.aws_iam_policy_document.security_audit_trust.json
  max_session_duration = 3600

  tags = {
    Project     = "aws-multi-account-landing-zone"
    ManagedBy   = "Terraform"
    Environment = var.environment
    Purpose     = "SecurityAudit"
  }

  depends_on = [
    terraform_data.account_guard
  ]
}

resource "aws_iam_role_policy_attachment" "security_audit" {
  role       = aws_iam_role.security_audit.name
  policy_arn = "arn:aws:iam::aws:policy/SecurityAudit"
}