terraform {
  required_providers {
    ns = {
      source = "nullstone-io/ns"
    }
  }
}

data "ns_workspace" "this" {}

data "ns_connection" "network" {
  name = "network"
  type = "network/aws"
}

data "ns_connection" "postgres" {
  name     = "postgres"
  type     = "postgres/aws-rds"
  optional = true
}

locals {
  db_user_security_group_id = try(data.ns_connection.postgres.outputs.db_user_security_group_id, "")
}
