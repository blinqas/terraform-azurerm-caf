
#
# Use keyvault for vm admin_username and admin_password, this can be convinient if you work with locked down 3rd party appliances who not support ssh keys (recomended to use ssh keys when possible)
# Keyvault can be in remote state and in a different subscription, ex security landing zone subscription
#

locals {
  # To shorten the addresses used in the logic
  vm_settings      = try(var.settings.virtual_machine_settings, {})
  os_settings      = try(var.settings.virtual_machine_settings[var.settings.os_type], "")
  admin_user_kv    = try(var.settings.virtual_machine_settings[var.settings.os_type].admin_user_keyvault, {})
  creation_secrets = try(var.settings.virtual_machine_settings[var.settings.os_type].admin_user_keyvault.creation_secrets, {})
  password_policy  = try(var.settings.virtual_machine_settings[var.settings.os_type].admin_user_keyvault.creation_secrets.admin_password_policy, {})
  # Use keyvault for admin_username and admin_password? True only if vm_settings.admin_user not defined and admin_user_keyvault.key is defined
  # use_kv_for_admin_user = (can(local.os_settings.admin_password) == false) && can(local.os_settings.admin_user_keyvault.key)
  use_kv_for_admin_user = !(local.os_settings.disable_password_authentication) && can(local.os_settings.admin_user_keyvault.key)
  # Create admin_user kv secret only if admin_user_keyvault.creation_secrets.admin_user is defined
  create_secrets_for_admin_user = (local.use_kv_for_admin_user) && (can(local.os_settings.admin_username) || can(local.creation_secrets.admin_username))
  # Kv can be local or remote and addressed through virtual_machine_settings.keyvault.key or os_settings.admin_user_keyvault.key
  kv_to_use         = var.keyvaults[try(local.os_settings.admin_user_keyvault.lz_key, var.client_config.landingzone_key)][try(local.os_settings.admin_user_keyvault.key, local.vm_settings.keyvault)]
  use_secret_prefix = try(local.admin_user_kv.prefix_secret_names_with_vm_name, false)

  # Existing secret in keyvault overrule os_settings.admin_username, who overrule creation_secrets.admin_username.
  admin_username_linux = try(data.azurerm_key_vault_secret.admin_username.0.value,
    local.os_settings.admin_username,
  local.creation_secrets.admin_username, null)

  # Existing secret in keyvault overrule os_settings.admin_password, who overrule creation_secrets.admin_password, who overrule the random_password generated when none value is configured
  admin_password_linux = try(data.azurerm_key_vault_secret.admin_password.0.value,
    local.os_settings.admin_password,
    local.creation_secrets.admin_password,
  azurerm_key_vault_secret.admin_password_resource.0.value, null)

  # Preparations to easy adopt the same logic for windows servers
  admin_username = local.os_type == "windows" ? local.admin_username_windows : local.admin_username_linux
  admin_password = local.os_type == "windows" ? local.admin_password_windows : local.admin_password_linux

  # Secret names prefixed with computer_name to support multiple vm secrets in the same keyvault
  secret_names = (local.use_secret_prefix) ? {
    user = try(
      format("%s-admin-username", azurecaf_name.linux_computer_name[local.os_type].result),
      format("%s-admin-username", azurecaf_name.legacy_computer_name[local.os_type].result),
      format("%s-admin-username", azurecaf_name.windows_computer_name[local.os_type].result)
    ),
    password = try(
      format("%s-admin-password", azurecaf_name.linux_computer_name[local.os_type].result),
      format("%s-admin-password", azurecaf_name.legacy_computer_name[local.os_type].result),
      format("%s-admin-password", azurecaf_name.windows_computer_name[local.os_type].result)
    )
    } : {
    user     = "admin-username"
    password = "admin-password"
  }

  # Used for debugging during development, can be deleted
  debug = merge(tomap({ "vm_settings" = local.vm_settings }),
    tomap({ "os_settings" = local.os_settings }),
    tomap({ "use_kv_for_admin_user" = local.use_kv_for_admin_user }),
    tomap({ "create_secrets_for_admin_user" = local.create_secrets_for_admin_user }),
    tomap({ "create_secrets_for_admin_user" = local.create_secrets_for_admin_user }),
    tomap({ "kv_to_use" = local.kv_to_use }),
    tomap({ "admin_username_linux" = local.admin_username_linux }),
    tomap({ "admin_password_linux" = local.admin_password_linux }),
    tomap({ "var_settings_os_type" = var.settings.os_type }),
    tomap({ "random_password" = random_password.admin_password }),
    tomap({ "azurerm_key_vault_secret.admin_username" = try(data.azurerm_key_vault_secret.admin_username, null) }),
    tomap({ "azurerm_key_vault_secret.admin_password" = try(data.azurerm_key_vault_secret.admin_password, null) })
  )
}

# Use existing keyvault and secret for admin_username and password, receive all secrets to confirm they exist before referencing them
data "azurerm_key_vault_secrets" "admin_user" {
  key_vault_id = local.kv_to_use.id
}

locals {
  secret_exists_admin_username = contains(data.azurerm_key_vault_secrets.admin_user.names, local.secret_names.user)
  secret_exists_admin_password = contains(data.azurerm_key_vault_secrets.admin_user.names, local.secret_names.password)
}

data "azurerm_key_vault_secret" "admin_username" {
  count = local.create_secrets_for_admin_user && local.secret_exists_admin_username ? 1 : 0
  key_vault_id = local.kv_to_use.id
  name         = local.secret_names.user
}

# Use existing keyvault secret for admin_password
data "azurerm_key_vault_secret" "admin_password" {
  count = local.create_secrets_for_admin_user && local.secret_exists_admin_password ? 1 : 0
  key_vault_id = local.kv_to_use.id
  name         = local.secret_names.password
}

# If admin_password not defined in tfvars configuration, this random password will be used instead
resource "random_password" "admin_password" {
  /*keepers = {
    frequency = time_rotating.key.0.rotation_rfc3339
  }
  */
  length      = try(local.password_policy.length, 30)
  special     = try(local.password_policy.special, true)
  lower       = try(local.password_policy.lower, true)
  upper       = try(local.password_policy.upper, true)
  numeric     = try(local.password_policy.numeric, true)
  min_lower   = try(local.password_policy.min_lower, 1)
  min_upper   = try(local.password_policy.min_upper, 1)
  min_special = try(local.password_policy.min_special, 1)
}

# Create new keyvault secret for admin_username
resource "azurerm_key_vault_secret" "admin_username_resource" {
  count = local.create_secrets_for_admin_user && !(local.secret_exists_admin_username) ? 1 : 0
  name  = local.secret_names.user
  # Username from keyvault overrule configuration, os_settings.admin_username overrule os_settings.creation_secrets.admin_username
  value        = try(data.azurerm_key_vault_secret.admin_username.0.value, local.os_settings.admin_username, local.creation_secrets.admin_username)
  key_vault_id = local.kv_to_use.id

  lifecycle {
    prevent_destroy = true
    ignore_changes  = [value, key_vault_id]
  }
}

# Create new keyvault secret for admin_password
resource "azurerm_key_vault_secret" "admin_password_resource" {
  count = local.create_secrets_for_admin_user && !(local.secret_exists_admin_password) ? 1 : 0
  name  = local.secret_names.password
  # If keyvault allready have a admin_password this will overrule tfvar configuration, os_settings.admin_password overrule os_settings.creation_secrets.admin_password who overrule the random_password
  value        = try(data.azurerm_key_vault_secret.admin_password.0.value, local.creation_secrets.admin_password, random_password.admin_password.result)
  key_vault_id = local.kv_to_use.id

  lifecycle {
    prevent_destroy = true
    ignore_changes  = [value, key_vault_id]
  }
}
