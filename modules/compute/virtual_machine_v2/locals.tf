/*
locals {



  admin_username           = can(local.virtual_machine_settings.admin_username_key) ? data.azurerm_key_vault_secret.admin_username.0.result.value : can(local.virtual_machine_settings.admin_username) ? local.virtual_machine_settings.admin_username : null
  admin_password           = can(local.virtual_machine_settings.admin_password_key) ? data.azurerm_key_vault_secret.admin_password.0.result.value : can(local.virtual_machine_settings.admin_password) ? local.virtual_machine_settings.admin_password : null


}
*/