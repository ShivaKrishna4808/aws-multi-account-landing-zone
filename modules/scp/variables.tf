variable "policy_name" {
  description = "Name of the Service Control Policy"
  type        = string
}

variable "description" {
  description = "Description of the Service Control Policy"
  type        = string
}

variable "policy_content" {
  description = "JSON content of the Service Control Policy"
  type        = string
}

variable "target_id" {
  description = "AWS Organization root, OU, or account ID receiving the policy"
  type        = string
}