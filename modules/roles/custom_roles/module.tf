locals {
  settings = merge(var.global_settings, try(var.custom_role.settings, {}))
}

resource "azurecaf_name" "custom_role" {
  count         = try(local.settings.bypass_azurecaf_name, false) ? 0 : 1
  name          = var.custom_role.name
  resource_type = "azurerm_resource_group"
  #TODO: need to be changed to appropriate resource (no caf reference for now)
  prefixes      = local.settings.prefixes
  random_length = local.settings.random_length
  clean_input   = try(local.settings.clean_input, true)
  passthrough   = local.settings.passthrough
  use_slug      = local.settings.use_slug
}

resource "azurerm_role_definition" "custom_role" {
  name = try(local.settings.bypass_azurecaf_name, false) ? var.custom_role.name : azurecaf_name.custom_role[0].result

  # TODO: refactor scope to include other scopes like RG, resources.
  scope       = lookup(var.custom_role, "scope", var.subscription_primary)
  description = var.custom_role.description

  permissions {
    actions          = lookup(var.custom_role.permissions, "actions", [])
    not_actions      = lookup(var.custom_role.permissions, "not_actions", [])
    data_actions     = lookup(var.custom_role.permissions, "data_actions", [])
    not_data_actions = lookup(var.custom_role.permissions, "not_data_actions", [])
  }

  # As recommended by the provider, we're assigning the `scope` object_id as the first
  # entry for `assignable_scopes`
  # Also, the distinct function will avoid duplicating entries
  # https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_definition#scope
  assignable_scopes = distinct(concat([lookup(var.custom_role, "scope", var.subscription_primary)], var.assignable_scopes))

}