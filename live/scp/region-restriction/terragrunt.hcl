include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}/modules/scp"
}

dependency "organizational_units" {
  config_path = "../../organizational-units"
}

inputs = {
  policy_name = "RestrictRegions"

  description = "Restricts workload accounts to approved AWS Regions."

  policy_content = file("${get_repo_root()}/policies/scp/restrict-regions.json")

  target_id = dependency.organizational_units.outputs.organizational_unit_ids["Workloads"]
}