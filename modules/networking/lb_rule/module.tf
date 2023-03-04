

resource "azurecaf_name" "lb" {
  name          = var.settings.name
  resource_type = "azurerm_data_factory" #"azurerm_lb_rule"
  prefixes      = try(var.settings.azurecaf_name.prefixes, var.global_settings.prefixes)
  random_length = try(var.settings.azurecaf_name.random_length, var.global_settings.random_length)
  clean_input   = true
  passthrough   = try(var.settings.azurecaf_name.passthrough, var.global_settings.passthrough)
  use_slug      = try(var.settings.azurecaf_name.use_slug, var.global_settings.use_slug)
}
resource "azurerm_lb_rule" "lb" {
  name = azurecaf_name.lb.result
  # resource_group_name      = var.resource_group_name     // blinQ: Not supported argument with azurerm v3.29.1
  loadbalancer_id                = can(var.settings.loadbalancer.id) ? var.settings.loadbalancer.id : var.remote_objects.lb[try(var.settings.loadbalancer.lz_key, var.client_config.landingzone_key)][var.settings.loadbalancer.key].id
  frontend_ip_configuration_name = var.settings.frontend_ip_configuration_name
  protocol                       = var.settings.protocol
  frontend_port                  = var.settings.frontend_port
  backend_port                   = var.settings.backend_port
  backend_address_pool_ids       = try(local.backend_address_pool_ids, null)
  probe_id                       = try(can(var.settings.probe.id) ? var.settings.probe.id : can(var.settings.probe_id) ? var.settings.probe_id : var.remote_objects.lb_probe[try(var.settings.probe.lz_key, var.client_config.landingzone_key)][try(var.settings.probe.key, var.settings.probe_key)].id, null)
  enable_floating_ip             = try(var.settings.enable_floating_ip, null)
  idle_timeout_in_minutes        = try(var.settings.idle_timeout_in_minutes, null)
  load_distribution              = try(var.settings.load_distribution, null)
  disable_outbound_snat          = try(var.settings.disable_outbound_snat, null)
  enable_tcp_reset               = try(var.settings.enable_tcp_reset, null)
}

locals {
  backend_address_pool_ids = flatten(element([
    for pool in keys(var.settings.backend_address_pools) : [
      (var.remote_objects.lb_backend_address_pool[try(var.settings.backend_address_pools[var.settings.backend_address_pools.key][pool].lz_key, var.client_config.landingzone_key)][var.settings.backend_address_pools[pool].key].id)
    ]
  ],0))
}
