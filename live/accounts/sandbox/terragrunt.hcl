include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}/modules/account-factory"
}

dependency "organizational_units" {
  config_path = "../../organizational-units"
}

inputs = {
  account_name  = "landing-zone-sandbox"
  account_email = get_env("TG_ACCOUNT_EMAIL")

  parent_id = dependency.organizational_units.outputs.organizational_unit_ids["Workloads"]

  role_name = "OrganizationAccountAccessRole"

  tags = {
    Environment = "Sandbox"
    Purpose     = "Portfolio"
  }
}