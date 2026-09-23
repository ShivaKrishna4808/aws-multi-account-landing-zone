include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}/modules/account-factory"
}

dependency "organizational_units" {
  config_path = "../organizational-units"
}

inputs = {
  account_name  = get_env("TG_ACCOUNT_NAME")
  account_email = get_env("TG_ACCOUNT_EMAIL")

  parent_id = dependency.organizational_units.outputs.organizational_unit_ids[
    get_env("TG_ORGANIZATIONAL_UNIT")
  ]

  role_name = "OrganizationAccountAccessRole"

  tags = {
    Environment = get_env("TG_ENVIRONMENT")
    Owner       = get_env("TG_OWNER")
    Purpose     = "LandingZoneSelfService"
  }
}