# Multi-Account AWS Landing Zone Automation

A hands-on AWS portfolio project demonstrating automated provisioning,
governance, security, and standardization across multiple AWS accounts.

## Technologies

- AWS Organizations
- Terraform
- Terragrunt
- GitHub Actions
- GitHub OIDC
- Open Policy Agent (OPA)
- AWS IAM
- AWS CloudTrail
- AWS Config
- Amazon VPC

## Project Goals

- Build a reusable AWS multi-account landing zone
- Create and organize AWS accounts using AWS Organizations
- Implement Organizational Units (OUs)
- Apply Service Control Policies (SCPs)
- Standardize IAM roles and networking
- Centralize logging and auditing
- Use reusable Terraform modules
- Use Terragrunt for environment composition
- Validate infrastructure using OPA policy-as-code
- Automate validation and deployment using GitHub Actions
- Use GitHub OIDC instead of long-lived AWS credentials

## Planned AWS Organization Structure

Management Account

├── Security OU  
├── Platform OU  
└── Workloads OU  
    ├── Development  
    └── Sandbox  

## Automation Flow

Developer
→ GitHub Pull Request
→ Terraform Validation
→ Terraform Plan
→ OPA Policy Validation
→ GitHub Actions
→ AWS
→ Landing Zone Resources

## Project Status

Technical implementation complete. The live portfolio environment has been provisioned and validated across AWS Organizations, account automation, networking, security, governance, centralized logging, GitHub Actions, and OPA policy enforcement.

## Architecture

```mermaid
flowchart TD
    A[Developer / Platform User] --> B[Account Request YAML]

    B --> C[Pull Request]

    C --> D[JSON Schema Validation]
    C --> E[Terraform Format Validation]
    C --> F[Terragrunt Validation]
    C --> G[OPA Policy Tests]

    D --> H[Protected Main Branch]
    E --> H
    F --> H
    G --> H

    H --> I[GitHub Actions]

    I --> J[GitHub OIDC]

    J --> K[Plan Role]
    J --> L[Apply Role]

    K --> M[Sandbox Terraform Plan]
    M --> N[OPA Plan Validation]

    L --> O[Self-Service Account Factory]
    O --> P[AWS Organizations]

    P --> Q[Security OU]
    P --> R[Platform OU]
    P --> S[Workloads OU]

    S --> T[Sandbox Account]

    T --> U[Standard VPC]
    T --> V[Public / Private Subnets]

    P --> W[Service Control Policies]
    P --> X[Organization CloudTrail]
    X --> Y[Central Audit S3 Bucket]
```
## Evidence

- [Self-Service Account Factory Plan Validation](docs/evidence/account-factory-plan.md)
- [AWS Account Provisioning Metrics](docs/evidence/account-provisioning-metrics.md)
- [Member Account Security Baseline Guardrail](docs/evidence/security-baseline-guardrail.md)
- [Final Landing Zone Verification](docs/evidence/final-verification.md)
