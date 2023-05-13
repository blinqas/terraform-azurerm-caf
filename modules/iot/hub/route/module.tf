# naming convention
resource "azurecaf_name" "iothub_route" {
  name          = var.name
  resource_type = "azurerm_iothub_route"
  prefixes      = var.global_settings.prefixes
  random_length = var.global_settings.random_length
  clean_input   = true
  passthrough   = var.global_settings.passthrough
  use_slug      = var.global_settings.use_slug
}

resource "azurerm_iothub_route" "route" {
  resource_group_name = var.resource_group_name
  iothub_name         = var.iothub_name.name
  name                = azurecaf_name.iothub_route.result

  source         = var.settings.source
  condition      = var.settings.condition
  endpoint_names = var.endpoint_names
  enabled        = var.settings.enabled
}