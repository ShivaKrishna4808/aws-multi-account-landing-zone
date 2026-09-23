# Member Account Security Baseline Evidence

## Security Baseline

The Sandbox AWS member account is configured with:

- Account-level S3 Block Public Access
- EBS encryption by default
- IAM account password policy
- Cross-account LandingZoneSecurityAuditRole
- AWS managed SecurityAudit policy
- Terraform account-isolation safety guard

## Wrong-Account Safety Test

The Sandbox security baseline was intentionally executed without the Sandbox provider role.

Terraform authenticated to the AWS Organizations management account while the stack expected the Sandbox account.

The Terraform plan was blocked with:

Error: Resource precondition failed

Safety check failed: security baseline is running against the wrong AWS account.

No infrastructure changes were applied.

## Recovery Test

The Sandbox provider role was restored and Terraform was executed again.

Result:

No changes. Your infrastructure matches the configuration.

## Demonstrated Control

The test proves that the landing-zone stack:

1. Detects execution against the wrong AWS account.
2. Stops before modifying infrastructure.
3. Operates normally after the correct cross-account role is restored.

## Security Purpose

The account guard reduces the risk of accidentally deploying member-account infrastructure into the AWS Organizations management account.
