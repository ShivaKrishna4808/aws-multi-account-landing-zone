package terraform.guardrails

import rego.v1

#
# Guardrail 1:
# Prevent NAT Gateways in this portfolio environment.
#
# NAT Gateways have hourly and data-processing costs.
#
deny contains msg if {
	rc := input.resource_changes[_]
	rc.type == "aws_nat_gateway"
	rc.change.actions[_] == "create"

	msg := sprintf(
		"NAT Gateway creation is prohibited in the portfolio environment: %s",
		[rc.address],
	)
}

#
# Guardrail 2:
# Prevent SSH from being exposed to the entire Internet.
#
deny contains msg if {
	rc := input.resource_changes[_]
	rc.type == "aws_security_group_rule"
	rc.change.actions[_] == "create"

	after := rc.change.after

	after.type == "ingress"
	after.from_port <= 22
	after.to_port >= 22
	after.cidr_blocks[_] == "0.0.0.0/0"

	msg := sprintf(
		"Public SSH access is prohibited: %s allows port 22 from 0.0.0.0/0",
		[rc.address],
	)
}

#
# Guardrail 3:
# VPCs must have standard landing-zone tags.
#
deny contains msg if {
	rc := input.resource_changes[_]
	rc.type == "aws_vpc"
	rc.change.actions[_] == "create"

	tags := object.get(rc.change.after, "tags", {})

	object.get(tags, "Project", "") == ""

	msg := sprintf(
		"VPC %s is missing required Project tag",
		[rc.address],
	)
}

deny contains msg if {
	rc := input.resource_changes[_]
	rc.type == "aws_vpc"
	rc.change.actions[_] == "create"

	tags := object.get(rc.change.after, "tags", {})

	object.get(tags, "ManagedBy", "") == ""

	msg := sprintf(
		"VPC %s is missing required ManagedBy tag",
		[rc.address],
	)
}
