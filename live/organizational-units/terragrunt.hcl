include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}/modules/organizational-units"
}

dependency "organization" {
  config_path = "../organization"
}

inputs = {
  parent_id = dependency.organization.outputs.root_id

  organizational_units = [
    "Security",
    "Platform",
    "Workloads"
  ]
}