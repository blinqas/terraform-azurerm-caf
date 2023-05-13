
module "service_plans" {
  source = "./modules/webapps/service_plan"

  for_each = local.webapp.service_plans

  name                       = each.value.name
  location                   = can(local.global_settings.regions[each.value.region]) ? local.global_settings.regions[each.value.region] : local.combined_objects_resource_groups[try(each.value.resource_group.lz_key, local.client_config.landingzone_key)][try(each.value.resource_group.key, each.value.resource_group_key)].location
  resource_group_name        = can(each.value.resource_group.name) || can(each.value.resource_group_name) ? try(each.value.resource_group.name, each.value.resource_group_name) : local.combined_objects_resource_groups[try(each.value.resource_group.lz_key, local.client_config.landingzone_key)][try(each.value.resource_group_key, each.value.resource_group.key)].name
  base_tags                  = try(local.global_settings.inherit_tags, false) ? try(local.combined_objects_resource_groups[try(each.value.resource_group.lz_key, local.client_config.landingzone_key)][try(each.value.resource_group.key, each.value.resource_group_key)].tags, {}) : {}
  app_service_environment_id = can(each.value.app_service_environment_id) ? each.value.app_service_environment_id : try(local.combined_objects_app_service_environments_all[try(each.value.app_service_environment.lz_key, local.client_config.landingzone_key)][try(each.value.app_service_environment.key, each.value.app_service_environment_key)].id, null)

  tags            = try(each.value.tags, null)
  settings        = each.value
  global_settings = local.global_settings
}

output "service_plans" {
  value = module.service_plans
}
