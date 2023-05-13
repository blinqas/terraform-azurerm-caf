resource "random_password" "value" {
  length           = var.config.length
  special          = var.config.special
  override_special = var.config.override_special
  min_lower = try(var.config.min_lower, 0)
  min_numeric = try(var.config.min_numeric, 0)
  min_upper = try(var.config.min_upper, 0)
  min_special = try(var.config.min_special, 0)
  numeric = try(var.config.numeric, true)
  upper = try(var.config.upper, true)
  
}

resource "azurerm_key_vault_secret" "secret" {
  name         = var.name
  value        = random_password.value.result
  key_vault_id = var.keyvault_id

  lifecycle {
    ignore_changes = [
      key_vault_id
    ]
  }
}
