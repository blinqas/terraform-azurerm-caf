# Generate random password if no reference to existing keyvault password (admin_password_key)
resource "random_password" "admin" {
  count            = can(local.virtual_machine_settings.admin_password_key) ? 0 : 1
  length           = 123
  min_upper        = 2
  min_lower        = 2
  min_special      = 2
  numeric          = true
  special          = true
  override_special = "!@#$%&"
}

# Create keyvault secret for password
resource "azurerm_key_vault_secret" "admin_password" {
  for_each = try(var.settings.virtual_machine_settings[local.os_type].admin_password_key, null) == null ? var.settings.virtual_machine_settings : {}

  name         = format("%s-admin-password", azurecaf_name.windows_computer_name[each.key].result)
  value        = random_password.admin[local.os_type].result
  key_vault_id = local.keyvault.id

  lifecycle {
    ignore_changes = [
      value, key_vault_id
    ]
  }
}

locals {

  keyvault = var.settings.keyvault

  # identify keyvault secret name prefixes
  admin_username_prefix = can(local.keyvault.username.prefix_secret_name) ? contains(local.keyvault.username.prefix_secret_name, "vm-name") ? local.virtual_machine_settings.name : contains(local.keyvault.username.prefix_secret_name, "computer-name") ? local.virtual_machine_settings.computer_name : local.keyvault.username.prefix_secret_name : ""

  admin_password_prefix = can(local.keyvault.password.prefix_secret_name) ? contains(local.keyvault.password.prefix_secret_name, "vm-name") ? local.virtual_machine_settings.name : contains(local.keyvault.password.prefix_secret_name, "computer-name") ? local.virtual_machine_settings.computer_name : local.keyvault.password.prefix_secret_name : ""

  sshkey_prefix = can(local.keyvault.sshkey.prefix_secret_name) ? contains(local.keyvault.sshkey.prefix_secret_name, "vm-name") ? local.virtual_machine_settings.name : contains(local.keyvault.sshkey.prefix_secret_name, "computer-name") ? local.virtual_machine_settings.computer_name : local.keyvault.sshkey.prefix_secret_name : ""

  # identify full keyvault secret names (secret keys)
  admin_username_secret_key = concat(local.admin_username_prefix, local.keyvault.username.key)
  admin_password_secret_key = concat(local.admin_password_prefix, local.keyvault.password.key)
  sshkey_secret_prefix      = concat(local.sshkey_prefix, local.keyvault.sshkey.key)

}

# Retrive all existing secrets from keyvault
data "azurerm_key_vault_secrets" "keyvault" {
  count        = can(local.keyvault.id) ? 1 : 0
  key_vault_id = local.keyvault.id
}

locals {
  secret_exists_admin_username = try(contains(data.azurerm_key_vault_secrets.keyvault.0.names, local.admin_username_secret_key), false)
  secret_exists_admin_password = try(contains(data.azurerm_key_vault_secrets.keyvault.0.names, local.admin_password_secret_key), false)
  secret_exists_sshkey         = try(contains(data.azurerm_key_vault_secrets.keyvault.0.names, local.sshkey_secret_key), false)
}

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

resource "azurerm_key_vault_secret" "admin_password" {
  for_each = local.os_type == "windows" && try(var.settings.virtual_machine_settings[local.os_type].admin_password_key, null) == null ? var.settings.virtual_machine_settings : {}

  name         = format("%s-admin-password", azurecaf_name.windows_computer_name[each.key].result)
  value        = random_password.admin[local.os_type].result
  key_vault_id = local.keyvault.id

  lifecycle {
    ignore_changes = [
      value, key_vault_id
    ]
  }
}

#
# Get the admin username and password from keyvault
#

locals {
  admin_username = can(var.settings.virtual_machine_settings["windows"].admin_username_key) ? data.external.windows_admin_username.0.result.value : null
  admin_password = can(var.settings.virtual_machine_settings["windows"].admin_password_key) ? data.external.windows_admin_password.0.result.value : null
}

#
# Use data external to retrieve value from different subscription
#
# With for_each it is not possible to change the provider's subscription at runtime so using the following pattern.
#
data "external" "windows_admin_username" {
  count = try(var.settings.virtual_machine_settings["windows"].admin_username_key, var.settings.virtual_machine_settings["legacy"].admin_password_key, null) == null ? 0 : 1
  program = [
    "bash", "-c",
    format(
      "az keyvault secret show --name '%s' --vault-name '%s' --query '{value: value }' -o json",
      try(var.settings.virtual_machine_settings["windows"].admin_username_key, var.settings.virtual_machine_settings["legacy"].admin_username_key),
      local.keyvault.name
    )
  ]
}

data "external" "windows_admin_password" {
  count = try(var.settings.virtual_machine_settings["windows"].admin_password_key, var.settings.virtual_machine_settings["legacy"].admin_password_key, null) == null ? 0 : 1
  program = [
    "bash", "-c",
    format(
      "az keyvault secret show -n '%s' --vault-name '%s' --query '{value: value }' -o json",
      try(var.settings.virtual_machine_settings["windows"].admin_password_key, var.settings.virtual_machine_settings["legacy"].admin_password_key),
      local.keyvault.name
    )
  ]
}
