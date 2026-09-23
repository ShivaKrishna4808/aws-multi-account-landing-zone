variable "account_name" {
  description = "Friendly name of the AWS member account"
  type        = string
}

variable "account_email" {
  description = "Unique email address assigned to the AWS member account"
  type        = string
  sensitive   = true
}

variable "parent_id" {
  description = "Organizational Unit ID where the account will be created"
  type        = string
}

variable "role_name" {
  description = "IAM role created by AWS Organizations in the member account"
  type        = string
  default     = "OrganizationAccountAccessRole"
}

variable "tags" {
  description = "Tags assigned to the AWS account"
  type        = map(string)
  default     = {}
}