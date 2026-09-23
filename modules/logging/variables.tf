variable "trail_name" {
  description = "Name of the organization CloudTrail trail"
  type        = string
}

variable "bucket_name" {
  description = "S3 bucket used for centralized CloudTrail logs"
  type        = string
}

variable "organization_id" {
  description = "AWS Organizations organization ID"
  type        = string
}

variable "management_account_id" {
  description = "AWS Organizations management account ID"
  type        = string
}

variable "aws_region" {
  description = "Home region for the organization trail"
  type        = string
  default     = "us-west-2"
}