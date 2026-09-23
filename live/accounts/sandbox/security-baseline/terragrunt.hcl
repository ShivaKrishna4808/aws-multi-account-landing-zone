include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}/modules/security-baseline"
}

dependency "organization" {
  config_path = "../../../organization"
}

inputs = {
  expected_account_id   = get_env("TG_SANDBOX_ACCOUNT_ID")
  management_account_id = dependency.organization.outputs.management_account_id
  environment           = "sandbox"
}