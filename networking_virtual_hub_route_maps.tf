#
#
# Virtual Hubs is used when deployed outside of the virtual wan
#
#

# Outputs
output "virtual_hub_route_maps" {
  value = module.virtual_hub_route_maps

  description = "Virtual hub route maps output"
}

module "virtual_hub_route_maps" {
  source   = "./modules/networking/virtual_hub_route_maps"
  for_each = local.networking.virtual_hub_route_maps

  name            = each.value.name
  client_config   = local.client_config
  global_settings = local.global_settings
  settings        = each.value
  virtual_hubs    = local.combined_objects_virtual_hubs
}

