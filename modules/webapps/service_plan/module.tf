resource "azurecaf_name" "app_service_plan" {
  name          = var.name
  resource_type = "azurerm_app_service_plan"
  prefixes      = var.global_settings.prefixes
  random_length = var.global_settings.random_length
  clean_input   = true
  passthrough   = var.global_settings.passthrough
  use_slug      = var.global_settings.use_slug
}

resource "azurerm_service_plan" "service_plan" {
  name                = azurecaf_name.app_service_plan.result
  resource_group_name = var.resource_group_name
  location            = var.location
  os_type             = var.settings.os_type
  sku_name            = var.settings.sku_name

  # Requires an Isolated SKU. Use one of I1, I2, I3 for azurerm_app_service_environment, or I1v2, I2v2, I3v2 for azurerm_app_service_environment_v3
  app_service_environment_id = try(var.settings.app_service_environment_id, null)
  
  maximum_elastic_worker_count = try(var.settings.maximum_elastic_worker_count, null)
  worker_count = try(var.settings.worker_count, null)
  per_site_scaling_enabled = try(var.settings.per_site_scaling_enabled, null)
  zone_balancing_enabled = try(var.settings.zone_balancing_enabled, null)
  tags = local.tags

}