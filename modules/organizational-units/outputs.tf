output "organizational_unit_ids" {
  description = "Map of Organizational Unit names to IDs"

  value = {
    for name, ou in aws_organizations_organizational_unit.this :
    name => ou.id
  }
}