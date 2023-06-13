module "private_endpoint" {
  source   = "../../networking/private_endpoint"
  for_each = var.private_endpoints

  resource_id         = azurerm_function_app.function_app.id
  name                = each.value.name
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.vnets[try(each.value.subnet.lz_key, each.value.lz_key, var.client_config.landingzone_key)][try(each.value.subnet.vnet_key, each.value.vnet_key)].subnets[try(each.value.subnet.key, each.value.subnet_key)].id
  settings            = each.value
  global_settings     = var.global_settings
  base_tags           = local.tags
  private_dns         = var.private_dns
  client_config       = var.client_config
}