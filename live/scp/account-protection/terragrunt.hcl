include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}/modules/scp"
}

dependency "organization" {
  config_path = "../../organization"
}

inputs = {
  policy_name = "DenyAccountDeparture"

  description = "Prevents member accounts from leaving the organization or closing themselves."

  policy_content = file("${get_repo_root()}/policies/scp/deny-account-departure.json")

  target_id = dependency.organization.outputs.root_id
}