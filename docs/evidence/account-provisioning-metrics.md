# AWS Account Provisioning Metrics

## Sandbox Account Creation

AWS Organizations recorded the successful creation of the portfolio sandbox account.

- Account: `landing-zone-sandbox`
- State: `SUCCEEDED`
- Requested: `2026-09-23T07:32:37.968000-07:00`
- Completed: `2026-09-23T07:32:44.556000-07:00`
- AWS Organizations `CreateAccount` duration: **6.588 seconds**

## GitHub Account Factory Pipeline

A plan-only self-service account request was executed through the GitHub Actions Account Factory workflow.

- Workflow conclusion: `success`
- Workflow started: `2026-09-23T19:51:04Z`
- Workflow completed: `2026-09-23T19:52:06Z`
- End-to-end GitHub workflow duration: **62 seconds**
- Account Factory job duration: **58 seconds**
- Terraform result: `Plan: 1 to add, 0 to change, 0 to destroy.`
- Apply mode: disabled
- Additional AWS account created: no

## Measurement Scope

The **6.588-second** measurement represents the AWS Organizations `CreateAccount` operation for the existing sandbox account.

The **62-second** measurement represents the self-service GitHub Actions validation and Terraform planning pipeline.

These measurements should not be combined and described as a complete end-to-end landing-zone provisioning duration.
