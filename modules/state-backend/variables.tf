variable "bucket_name" {
  description = "S3 bucket used for Terraform remote state"
  type        = string
}

variable "aws_region" {
  description = "AWS region for Terraform state"
  type        = string
  default     = "us-west-2"
}