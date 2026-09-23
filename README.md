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

Currently under active development.