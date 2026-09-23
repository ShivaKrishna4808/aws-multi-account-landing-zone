resource "aws_organizations_organizational_unit" "this" {
  for_each = toset(var.organizational_units)

  name      = each.value
  parent_id = var.parent_id

  tags = {
    Name      = each.value
    Project   = "aws-multi-account-landing-zone"
    ManagedBy = "Terraform"
  }
}