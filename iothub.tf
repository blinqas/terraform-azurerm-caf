module "iothubs" {
  source = "./modules/iot/hub"
  # depends_on = [module.networking]
  for_each = local.iothubs

  name            = each.value.name
  global_settings = local.global_settings  
  settings        = each.value
  tags            = try(each.value.tags, null)

  client_config       = local.client_config

  location = can(local.global_settings.regions[each.value.region]) ? local.global_settings.regions[each.value.region] : local.combined_objects_resource_groups[try(each.value.resource_group.lz_key, local.client_config.landingzone_key)][try(each.value.resource_group.key, each.value.resource_group_key)].location

  base_tags = try(local.global_settings.inherit_tags, false) ? try(local.combined_objects_resource_groups[try(each.value.resource_group.lz_key, local.client_config.landingzone_key)][try(each.value.resource_group.key, each.value.resource_group_key)].tags, {}) : {}

  resource_group_name = can(each.value.resource_group.name) || can(each.value.resource_group_name) ? try(each.value.resource_group.name, each.value.resource_group_name) : local.combined_objects_resource_groups[try(each.value.resource_group.lz_key, local.client_config.landingzone_key)][try(each.value.resource_group_key, each.value.resource_group.key)].name

  remote_objects = {
    managed_identities = local.combined_objects_managed_identities
    storage_accounts   = local.combined_objects_storage_accounts
  }

}
