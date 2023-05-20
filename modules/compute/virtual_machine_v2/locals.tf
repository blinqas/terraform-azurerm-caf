locals {
  os_type                  = lower(var.settings.os_type)
  virtual_machine_settings = try(var.settings.virtual_machine_settings[local.os_type], var.settings.virtual_machine_settings["legacy"])
  keyvault                 = try(var.keyvaults[var.settings.lz_key][var.settings.keyvault_key], var.keyvaults[try(var.settings.keyvault.lz_key, var.client_config.landingzone_key)][try(var.settings.keyvault.key, var.settings.keyvault_key)], null)
  admin_password_key       = try(local.virtual_machine_settings.admin_password_key, null)
  admin_username_key       = try(local.virtual_machine_settings.admin_username_key, null)
  admin_username           = can(local.virtual_machine_settings.admin_username_key) ? data.azurerm_key_vault_secret.admin_username.0.result.value : can(local.virtual_machine_settings.admin_username) ? local.virtual_machine_settings.admin_username : null
  admin_password           = can(local.virtual_machine_settings.admin_password_key) ? data.azurerm_key_vault_secret.admin_password.0.result.value : can(local.virtual_machine_settings.admin_password) ? local.virtual_machine_settings.admin_password : null

  tags = merge(var.base_tags, local.module_tag, try(var.settings.tags, null))
  module_tag = {
    "module" = basename(abspath(path.module))
  }
}
