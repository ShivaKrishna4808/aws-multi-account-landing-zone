include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}/modules/logging"
}

dependency "organization" {
  config_path = "../organization"
}

inputs = {
  trail_name = "landing-zone-organization-trail"

  bucket_name = "aws-malz-audit-${get_aws_account_id()}-us-west-2"

  organization_id = dependency.organization.outputs.organization_id

  management_account_id = dependency.organization.outputs.management_account_id

  aws_region = "us-west-2"
}