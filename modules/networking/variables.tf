variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block assigned to the VPC"
  type        = string
}

variable "availability_zones" {
  description = "Availability Zones used by the VPC"
  type        = list(string)

  validation {
    condition     = length(var.availability_zones) == 2
    error_message = "Exactly two Availability Zones must be supplied."
  }
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)

  validation {
    condition     = length(var.public_subnet_cidrs) == 2
    error_message = "Exactly two public subnet CIDRs must be supplied."
  }
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)

  validation {
    condition     = length(var.private_subnet_cidrs) == 2
    error_message = "Exactly two private subnet CIDRs must be supplied."
  }
}

variable "expected_account_id" {
  description = "AWS account ID where this network must be deployed"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "sandbox"
}