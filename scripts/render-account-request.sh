#!/usr/bin/env bash

set -euo pipefail

REQUEST_FILE="${1:?Usage: render-account-request.sh <request.yaml>}"

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

ACCOUNT_NAME="$(yq -r '.account.name' "$REQUEST_FILE")"
ENVIRONMENT="$(yq -r '.account.environment' "$REQUEST_FILE")"
OU="$(yq -r '.account.organizational_unit' "$REQUEST_FILE")"
OWNER="$(yq -r '.account.owner' "$REQUEST_FILE")"

TARGET_DIR="${PROJECT_ROOT}/live/generated/${ACCOUNT_NAME}"

mkdir -p "$TARGET_DIR"

cat > "${TARGET_DIR}/terragrunt.hcl" <<EOF
include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "\${get_repo_root()}/modules/account-factory"
}

dependency "organizational_units" {
  config_path = "../../organizational-units"
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
EOF

echo "Generated account stack:"
echo "$TARGET_DIR"

echo "TG_ACCOUNT_NAME=$ACCOUNT_NAME"
echo "TG_ENVIRONMENT=$ENVIRONMENT"
echo "TG_ORGANIZATIONAL_UNIT=$OU"
echo "TG_OWNER=$OWNER"