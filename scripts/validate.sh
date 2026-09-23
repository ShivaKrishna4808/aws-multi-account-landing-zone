#!/usr/bin/env bash

set -euo pipefail

PLAN_JSON="${1:-tfplan.json}"

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
POLICY="${PROJECT_ROOT}/policies/opa/terraform.rego"

echo "========================================"
echo " AWS Landing Zone Policy Validation"
echo "========================================"

if [[ ! -f "$PLAN_JSON" ]]; then
  echo "ERROR: Terraform plan JSON not found: $PLAN_JSON"
  exit 1
fi

echo
echo "Running OPA policy tests..."

opa test "${PROJECT_ROOT}/policies/opa" -v

echo
echo "Evaluating Terraform plan..."

VIOLATIONS="$(
  opa eval \
    --format=raw \
    --data "$POLICY" \
    --input "$PLAN_JSON" \
    'count(data.terraform.guardrails.deny)'
)"

if [[ "$VIOLATIONS" -gt 0 ]]; then
  echo
  echo "POLICY VALIDATION FAILED"
  echo "Detected ${VIOLATIONS} violation(s):"
  echo

  opa eval \
    --format=pretty \
    --data "$POLICY" \
    --input "$PLAN_JSON" \
    'data.terraform.guardrails.deny'

  exit 1
fi

echo
echo "POLICY VALIDATION PASSED"
echo "No policy violations detected."