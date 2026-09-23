locals {
  aws_region = "us-west-2"
  account_id = get_aws_account_id()

  state_bucket = "aws-malz-tfstate-${local.account_id}-${local.aws_region}"

  # Optional cross-account role used by workloads such as Sandbox networking.
  provider_role_arn = get_env("TG_PROVIDER_ROLE_ARN", "")

  assume_role_block = local.provider_role_arn != "" ? join("\n", [
    "  assume_role {",
    "    role_arn     = \"${local.provider_role_arn}\"",
    "    session_name = \"landing-zone-terraform\"",
    "  }"
  ]) : ""
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"

  contents = <<EOF
provider "aws" {
  region = "${local.aws_region}"

${local.assume_role_block}

  default_tags {
    tags = {
      Project   = "aws-multi-account-landing-zone"
      ManagedBy = "Terraform"
      Purpose   = "Portfolio"
    }
  }
}
EOF
}

remote_state {
  backend = "s3"

  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }

  config = {
    bucket       = local.state_bucket
    key          = "${path_relative_to_include()}/terraform.tfstate"
    region       = local.aws_region
    encrypt      = true
    use_lockfile = true
  }
}