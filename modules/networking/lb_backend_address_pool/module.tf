

resource "azurecaf_name" "lb" {
  name          = var.settings.name
  resource_type = "azurerm_data_factory" #"azurerm_lb_backend_address_pool"
  prefixes      = try(var.settings.azurecaf_name.prefixes, var.global_settings.prefixes)
  random_length = try(var.settings.azurecaf_name.random_length, var.global_settings.random_length)
  clean_input   = true
  passthrough   = try(var.settings.azurecaf_name.passthrough, var.global_settings.passthrough)
  use_slug      = try(var.settings.azurecaf_name.use_slug, var.global_settings.use_slug)
}
resource "azurerm_lb_backend_address_pool" "lb" {
  name            = azurecaf_name.lb.result
  loadbalancer_id = can(var.settings.loadbalancer.id) ? var.settings.loadbalancer.id : var.remote_objects.lb[try(var.settings.loadbalancer.lz_key, var.client_config.landingzone_key)][var.settings.loadbalancer.key].id
  dynamic "tunnel_interface" {
    for_each = try(var.settings.tunnel_interface, null) != null ? [var.settings.tunnel_interface] : []
    content {
      identifier = try(tunnel_interface.value.identifier, null)
      type       = try(tunnel_interface.value.type, null)
      protocol   = try(tunnel_interface.value.protocol, null)
      port       = try(tunnel_interface.value.port, null)
    }
  }
}
