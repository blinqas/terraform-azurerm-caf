

locals {

  tags = merge(var.base_tags, local.module_tag, try(var.settings.tags, null))
  module_tag = {
    "module" = basename(abspath(path.module))
  }

  os_type                  = lower(var.settings.os_type)
  virtual_machine_settings = try(var.settings.virtual_machine_settings[local.os_type], var.settings.virtual_machine_settings["legacy"])

  keyvault = try(var.keyvaults[var.settings.lz_key][var.settings.keyvault_key], var.keyvaults[try(var.settings.keyvault.lz_key, var.client_config.landingzone_key)][try(var.settings.keyvault.key, var.settings.keyvault_key)], null)

  password_policy = try(local.keyvault.password.policy, null)

  # identify keyvault secret name prefixes
  admin_username_prefix = can(local.keyvault.username.prefix_secret_name) ? contains(local.keyvault.username.prefix_secret_name, "vm-name") ? local.virtual_machine_settings.name : contains(local.keyvault.username.prefix_secret_name, "computer-name") ? local.virtual_machine_settings.computer_name : local.keyvault.username.prefix_secret_name : ""

  admin_password_prefix = can(local.keyvault.password.prefix_secret_name) ? contains(local.keyvault.password.prefix_secret_name, "vm-name") ? local.virtual_machine_settings.name : contains(local.keyvault.password.prefix_secret_name, "computer-name") ? local.virtual_machine_settings.computer_name : local.keyvault.password.prefix_secret_name : ""

  # sshkey_prefix = can(local.keyvault.sshkey.prefix_secret_name) ? contains(local.keyvault.sshkey.prefix_secret_name, "vm-name") ? local.virtual_machine_settings.name : contains(local.keyvault.sshkey.prefix_secret_name, "computer-name") ? local.virtual_machine_settings.computer_name : local.keyvault.sshkey.prefix_secret_name : ""

  # identify full keyvault secret names (secret keys)
  admin_username_secret_key = local.admin_username_prefix != "" ? concat(local.admin_username_prefix, "-", local.keyvault.username.key) : try(local.keyvault.username.key, local.virtual_machine_settings.admin_username_key)
  admin_password_secret_key = local.admin_password_prefix != "" ? concat(local.admin_password_prefix, "-", local.keyvault.password.key) : try(local.keyvault.password.key, local.virtual_machine_settings.admin_password_key)
  # sshkey_secret_prefix      = local.sshkey_prefix != "" ? concat(local.sshkey_prefix, "-", local.keyvault.sshkey.key) : local.keyvault.sshkey.key

}

# Retrive all existing secrets from keyvault
data "azurerm_key_vault_secrets" "keyvault" {
  count        = can(local.keyvault.id) ? 1 : 0
  key_vault_id = local.keyvault.id
}

# Check if secrets allready exsist in keyvault
locals {
  secret_exists_admin_username = try(contains(data.azurerm_key_vault_secrets.keyvault.0.names, local.admin_username_secret_key), false)
  secret_exists_admin_password = try(contains(data.azurerm_key_vault_secrets.keyvault.0.names, local.admin_password_secret_key), false)
  # secret_exists_sshkey         = try(contains(data.azurerm_key_vault_secrets.keyvault.0.names, local.sshkey_secret_key), false)
}

# --------------------- username ---------------------------
# Always create username secret, if secret name exist create dummy secret
resource "azurerm_key_vault_secret" "admin_username" {
  name         = local.secret_exists_admin_username ? "terraform-dummy-${replace(timestamp(), ":", "-")}" : local.admin_username_secret_key
  value        = try(local.keyvault.username.value, "admin")
  key_vault_id = local.keyvault.id

  lifecycle {
    ignore_changes = [
      value, name, key_vault_id
    ]
  }
}

# Mount data entity for admin_username secret
data "azurerm_key_vault_secret" "admin_username" {
  name         = local.admin_username_secret_key
  key_vault_id = local.keyvault.id
  depends_on = [
    azurerm_key_vault_secret.admin_username
  ]
}

# ------------------- password ---------------------
# Generate random password
resource "random_password" "admin" {
  length           = try(local.password_policy.length, 30)
  min_upper        = try(local.password_policy.min_upper, 1)
  min_lower        = try(local.password_policy.min_lower, 1)
  min_special      = try(local.password_policy.min_special, 1)
  numeric          = try(local.password_policy.numeric, true)
  lower            = try(local.password_policy.lower, true)
  upper            = try(local.password_policy.upper, true)
  special          = try(local.password_policy.special, true)
  override_special = try(local.password_policy.override_special, "!@#$%&")
}

# Always create password secret, if secret name exist create dummy secret
resource "azurerm_key_vault_secret" "admin_password" {
  name         = local.secret_exists_admin_password ? "terraform-dummy-${replace(timestamp(), ":", "-")}" : local.admin_password_secret_key
  value        = random_password.admin.result
  key_vault_id = local.keyvault.id

  lifecycle {
    ignore_changes = [
      value, name, key_vault_id
    ]
  }
}
# Mount data entity for admin_password secret
data "azurerm_key_vault_secret" "admin_password" {
  name         = local.admin_password_secret_key
  key_vault_id = local.keyvault.id
  depends_on = [
    azurerm_key_vault_secret.admin_username
  ]
}

# Create locals for admin_username and admin_password
locals {
  admin_username = try(data.azurerm_key_vault_secret.admin_username.value, local.keyvault.username.value, local.virtual_machine_settings.admin_username)
  admin_password = try(data.azurerm_key_vault_secret.admin_password.value, local.keyvault.password.value, local.virtual_machine_settings.admin_password)
}
