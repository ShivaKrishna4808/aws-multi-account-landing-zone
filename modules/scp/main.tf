resource "aws_organizations_policy" "this" {
  name        = var.policy_name
  description = var.description
  type        = "SERVICE_CONTROL_POLICY"
  content     = var.policy_content

  tags = {
    Project   = "aws-multi-account-landing-zone"
    ManagedBy = "Terraform"
  }
}

resource "aws_organizations_policy_attachment" "this" {
  policy_id = aws_organizations_policy.this.id
  target_id = var.target_id
}