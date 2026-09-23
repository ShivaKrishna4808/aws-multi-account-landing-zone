# Multi-Account AWS Landing Zone — Final Verification

## Organization

Verified:

- AWS Organizations enabled with all features
- Security OU
- Platform OU
- Workloads OU
- Sandbox member account in ACTIVE state

## Governance

Verified Service Control Policies:

- `DenyAccountDeparture` attached at the organization root
- `RestrictRegions` attached to the Workloads OU
- `FullAWSAccess` retained as the standard AWS-managed baseline SCP

Region enforcement was tested from the Sandbox account.

Approved region:

    us-west-2 -> EC2 API request succeeded

Restricted region:

    us-east-1 -> UnauthorizedOperation
    explicit deny in a service control policy

## Centralized Logging

The organization CloudTrail was verified with:

    IsLogging: True

CloudTrail delivers centralized organization audit events to the landing-zone audit S3 bucket.

## Sandbox Networking

Verified landing-zone VPC:

    CIDR: 10.20.0.0/16
    State: available

Verified four subnets across two Availability Zones:

    10.20.1.0/24   us-west-2a
    10.20.2.0/24   us-west-2b
    10.20.11.0/24  us-west-2a
    10.20.12.0/24  us-west-2b

Automatic public IP assignment is disabled on all four subnets.

## Member Account Security Baseline

Verified:

- EBS encryption by default enabled
- Account-level S3 Block Public Access enabled
- IAM minimum password length: 14
- Uppercase, lowercase, numeric, and symbol requirements enabled
- Password maximum age: 90 days
- Password reuse prevention: 24 passwords
- Cross-account `LandingZoneSecurityAuditRole`
- AWS managed `SecurityAudit` policy attachment

## Account Isolation Guardrail

Terraform was deliberately executed against the AWS Organizations management account while the Sandbox stack expected the member account.

Execution was stopped by the Terraform precondition:

    Safety check failed: security baseline is running against the wrong AWS account.

After restoring the Sandbox provider role:

    No changes. Your infrastructure matches the configuration.

## CI/CD and Policy Enforcement

Verified:

- Protected `main` branch
- Required Terraform and OPA PR validation
- Terraform formatting validation
- Terragrunt formatting validation
- JSON Schema validation for account requests
- OPA unit tests
- Real Sandbox Terraform plan generation
- OPA Terraform-plan evaluation
- GitHub OIDC authentication
- Separate Plan and Apply IAM roles
- OPA demonstrated blocking a prohibited NAT Gateway change

## Self-Service Account Factory

A YAML account request successfully passed the Account Factory pipeline.

Plan-only result:

    Plan: 1 to add, 0 to change, 0 to destroy.

No additional AWS account was created during the validation test.

Measured GitHub workflow duration:

    62 seconds

Existing Sandbox AWS Organizations CreateAccount operation:

    6.588 seconds

These measurements represent separate operations and are not presented as a complete end-to-end provisioning duration.

## Final Status

The portfolio implementation demonstrates a functioning multi-account AWS landing zone with:

- Account provisioning automation
- Organizational governance
- Cross-account execution
- Network standardization
- Security baselines
- Centralized audit logging
- Policy-as-code
- CI/CD guardrails
- Self-service account requests
- Wrong-account deployment protection
