resource "azurecaf_name" "lb" {
  name          = var.settings.name
  resource_type = "azurerm_lb" #"azurerm_lb_nat_pool"
  prefixes      = try(var.settings.azurecaf_name.prefixes, var.global_settings.prefixes)
  random_length = try(var.settings.azurecaf_name.random_length, var.global_settings.random_length)
  clean_input   = try(var.settings.azurecaf_name.clean_input, true)
  passthrough   = try(var.settings.azurecaf_name.passthrough, var.global_settings.passthrough)
  use_slug      = try(var.settings.azurecaf_name.use_slug, var.global_settings.use_slug)
}
resource "azurerm_lb_nat_pool" "lb" {
  name                           = azurecaf_name.lb.result
  resource_group_name            = var.resource_group_name
  loadbalancer_id                = can(var.settings.loadbalancer.id) ? var.settings.loadbalancer.id : var.remote_objects.lb[try(var.settings.loadbalancer.lz_key, var.client_config.landingzone_key)][var.settings.loadbalancer.key].id
  frontend_ip_configuration_name = var.settings.frontend_ip_configuration_name
  protocol                       = var.settings.protocol
  frontend_port_start            = var.settings.frontend_port_start
  frontend_port_end              = var.settings.frontend_port_end
  backend_port                   = var.settings.backend_port
  idle_timeout_in_minutes        = try(var.settings.idle_timeout_in_minutes, null)
  floating_ip_enabled            = try(var.settings.floating_ip_enabled, null)
  tcp_reset_enabled              = try(var.settings.tcp_reset_enabled, null)
}