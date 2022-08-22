
module "caps" {
  source  = "nullstone-modules/cap-merge/ns"
  modules = local.modules
}

locals {
  modules       = []
  capabilities  = module.caps.outputs
}
