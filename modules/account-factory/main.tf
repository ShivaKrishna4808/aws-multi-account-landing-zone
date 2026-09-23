resource "aws_organizations_account" "this" {
  name      = var.account_name
  email     = var.account_email
  parent_id = var.parent_id

  role_name = var.role_name

  iam_user_access_to_billing = "DENY"

  # Important safety setting:
  # Removing this Terraform resource will NOT automatically close the AWS account.
  close_on_deletion = false

  tags = merge(
    var.tags,
    {
      Name      = var.account_name
      ManagedBy = "Terraform"
      Project   = "aws-multi-account-landing-zone"
    }
  )

  lifecycle {
    prevent_destroy = true
  }
}