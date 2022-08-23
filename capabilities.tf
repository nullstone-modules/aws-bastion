provider "ns" {
  capability_id = 509
  alias         = "cap_509"
}

module "cap_509" {
  source  = "api.nullstone.io/nullstone/aws-postgres-access/any"
  

  app_metadata = local.app_metadata
  database_name = jsondecode("\"\"")

  providers = {
    ns = ns.cap_509
  }
}

module "caps" {
  source  = "nullstone-modules/cap-merge/ns"
  modules = local.modules
}

locals {
  modules       = [module.cap_509]
  capabilities  = module.caps.outputs
}
