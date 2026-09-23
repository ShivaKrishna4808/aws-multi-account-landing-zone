variable "expected_account_id" {
  description = "AWS account ID where the security baseline is allowed to run"
  type        = string
}

variable "management_account_id" {
  description = "AWS Organizations management account ID"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}