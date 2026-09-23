include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}/modules/github-oidc"
}

dependency "sandbox" {
  config_path = "../accounts/sandbox"
}

locals {
  management_account_id = get_aws_account_id()
}

inputs = {
  github_owner         = "ShivaKrishna4808"
  github_owner_id      = "205281864"
  github_repository    = "aws-multi-account-landing-zone"
  github_repository_id = "1383898745"

  terraform_state_bucket = "aws-malz-tfstate-${local.management_account_id}-us-west-2"

  sandbox_account_id = dependency.sandbox.outputs.account_id
}