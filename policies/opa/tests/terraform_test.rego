package terraform.guardrails_test

import rego.v1

test_denies_nat_gateway if {
	mock_plan := {
		"resource_changes": [
			{
				"address": "aws_nat_gateway.example",
				"type": "aws_nat_gateway",
				"change": {
					"actions": ["create"],
					"after": {},
				},
			},
		],
	}

	denials := data.terraform.guardrails.deny with input as mock_plan

	count(denials) == 1
}

test_denies_public_ssh if {
	mock_plan := {
		"resource_changes": [
			{
				"address": "aws_security_group_rule.ssh",
				"type": "aws_security_group_rule",
				"change": {
					"actions": ["create"],
					"after": {
						"type": "ingress",
						"from_port": 22,
						"to_port": 22,
						"cidr_blocks": ["0.0.0.0/0"],
					},
				},
			},
		],
	}

	denials := data.terraform.guardrails.deny with input as mock_plan

	count(denials) == 1
}

test_denies_vpc_without_required_tags if {
	mock_plan := {
		"resource_changes": [
			{
				"address": "aws_vpc.example",
				"type": "aws_vpc",
				"change": {
					"actions": ["create"],
					"after": {
						"cidr_block": "10.50.0.0/16",
						"tags": {
							"Name": "example-vpc",
						},
					},
				},
			},
		],
	}

	denials := data.terraform.guardrails.deny with input as mock_plan

	count(denials) == 2
}

test_allows_compliant_vpc if {
	mock_plan := {
		"resource_changes": [
			{
				"address": "aws_vpc.example",
				"type": "aws_vpc",
				"change": {
					"actions": ["create"],
					"after": {
						"cidr_block": "10.50.0.0/16",
						"tags": {
							"Name": "example-vpc",
							"Project": "aws-multi-account-landing-zone",
							"ManagedBy": "Terraform",
						},
					},
				},
			},
		],
	}

	denials := data.terraform.guardrails.deny with input as mock_plan

	count(denials) == 0
}
