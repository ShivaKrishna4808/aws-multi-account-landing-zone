include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}/modules/networking"
}

inputs = {
  vpc_name = "landing-zone-sandbox-vpc"
  vpc_cidr = "10.20.0.0/16"

  availability_zones = [
    "us-west-2a",
    "us-west-2b"
  ]

  public_subnet_cidrs = [
    "10.20.1.0/24",
    "10.20.2.0/24"
  ]

  private_subnet_cidrs = [
    "10.20.11.0/24",
    "10.20.12.0/24"
  ]

  expected_account_id = get_env("TG_SANDBOX_ACCOUNT_ID")

  environment = "sandbox"
}