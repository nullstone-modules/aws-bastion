data "ns_connection" "network" {
  name     = "network"
  contract = "network/aws/vpc"
}

locals {
  vpc_id            = data.ns_connection.network.outputs.vpc_id
  public_subnet_ids = data.ns_connection.network.outputs.public_subnet_ids
}
