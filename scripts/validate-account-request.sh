#!/usr/bin/env bash

set -euo pipefail

REQUEST_FILE="${1:-account-requests/example.yaml}"

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SCHEMA="${PROJECT_ROOT}/schemas/account-request.json"

if [[ ! -f "$REQUEST_FILE" ]]; then
  echo "ERROR: Account request not found: $REQUEST_FILE"
  exit 1
fi

echo "========================================"
echo " AWS Landing Zone Account Request"
echo "========================================"

echo
echo "Validating: ${REQUEST_FILE}"

TEMP_JSON="$(mktemp)"
trap 'rm -f "$TEMP_JSON"' EXIT

yq -o=json "$REQUEST_FILE" > "$TEMP_JSON"

python3 -m jsonschema \
  --instance "$TEMP_JSON" \
  "$SCHEMA"

echo
echo "ACCOUNT REQUEST VALIDATION PASSED"