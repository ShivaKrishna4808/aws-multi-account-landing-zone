variable "github_owner" {
  description = "GitHub repository owner"
  type        = string
}

variable "github_owner_id" {
  description = "Immutable GitHub owner ID"
  type        = string
}

variable "github_repository" {
  description = "GitHub repository name"
  type        = string
}

variable "github_repository_id" {
  description = "Immutable GitHub repository ID"
  type        = string
}

variable "terraform_state_bucket" {
  description = "S3 bucket containing Terraform remote state"
  type        = string
}

variable "sandbox_account_id" {
  description = "AWS Sandbox member account ID"
  type        = string
}