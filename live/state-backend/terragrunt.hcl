include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}/modules/state-backend"
}

inputs = {
  bucket_name = "aws-malz-tfstate-${get_aws_account_id()}-us-west-2"
  aws_region  = "us-west-2"
}