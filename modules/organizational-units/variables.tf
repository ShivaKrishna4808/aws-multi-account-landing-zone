variable "parent_id" {
  description = "Parent AWS Organizations root or OU ID"
  type        = string
}

variable "organizational_units" {
  description = "Names of Organizational Units to create"
  type        = list(string)
}