resource "azurecaf_name" "lb" {
  name          = var.settings.name
  resource_type = "azurerm_lb"
  prefixes      = try(var.settings.azurecaf_name.prefixes, var.global_settings.prefixes)
  random_length = try(var.settings.azurecaf_name.random_length, var.global_settings.random_length)
  clean_input   = try(var.settings.azurecaf_name.clean_input, true)
  passthrough   = try(var.settings.azurecaf_name.passthrough, var.global_settings.passthrough)
  use_slug      = try(var.settings.azurecaf_name.use_slug, var.global_settings.use_slug)
}
resource "azurerm_lb" "lb" {
  name                = azurecaf_name.lb.result
  resource_group_name = var.resource_group_name
  location            = var.location

  dynamic "frontend_ip_configuration" {
    for_each = can(var.settings.frontend_ip_configurations) ? var.settings.frontend_ip_configurations : {}
    content {
      name                                               = try(frontend_ip_configuration.value.name, null)
      zones                                              = try(frontend_ip_configuration.value.zones, frontend_ip_configuration.value.availability_zone, null)
      subnet_id                                          = can(frontend_ip_configuration.value.subnet.key) ? var.remote_objects.virtual_network[try(frontend_ip_configuration.value.subnet.lz_key, var.client_config.landingzone_key)][frontend_ip_configuration.value.subnet.vnet_key].subnets[frontend_ip_configuration.value.subnet.key].id : try(frontend_ip_configuration.value.subnet.id, null)
      gateway_load_balancer_frontend_ip_configuration_id = try(frontend_ip_configuration.value.gateway_load_balancer_frontend_ip_configuration_id, null)
      private_ip_address                                 = try(frontend_ip_configuration.value.private_ip_address, null)
      private_ip_address_allocation                      = try(frontend_ip_configuration.value.private_ip_address_allocation, null)
      private_ip_address_version                         = try(frontend_ip_configuration.value.private_ip_address_version, null)
      public_ip_address_id                               = can(frontend_ip_configuration.value.public_ip_address.key) ? var.remote_objects.public_ip_addresses[try(frontend_ip_configuration.value.public_ip_address.lz_key, var.client_config.landingzone_key)][frontend_ip_configuration.value.public_ip_address.key].id : try(frontend_ip_configuration.value.public_ip_address.id, null)
      public_ip_prefix_id                                = try(frontend_ip_configuration.value.public_ip_prefix_id, null)
    }
  }
  sku      = try(var.settings.sku, null)
  sku_tier = try(var.settings.sku_tier, null)
  tags     = local.tags
}