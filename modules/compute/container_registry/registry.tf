resource "azurecaf_name" "acr" {
  name          = var.name
  resource_type = "azurerm_container_registry"
  prefixes      = var.global_settings.prefixes
  random_length = var.global_settings.random_length
  clean_input   = true
  passthrough   = var.global_settings.passthrough
  use_slug      = var.global_settings.use_slug
}

resource "azurerm_container_registry" "acr" {
  name                = azurecaf_name.acr.result
  resource_group_name = local.resource_group_name
  location            = local.location
  sku                 = var.sku
  admin_enabled       = var.admin_enabled
  tags                = local.tags

  dynamic "georeplications" {
    for_each = try(var.georeplications, {})

    content {
      location = var.global_settings.regions[georeplications.key]
      tags     = try(georeplications.value.tags)
    }
  }

  dynamic "network_rule_set" {
    for_each = try(var.network_rule_set, {})

    content {
      default_action = try(network_rule_set.value.default_action, "Allow")

      dynamic "ip_rule" {
        for_each = try(network_rule_set.value.ip_rules, {})

        content {
          action   = "Allow"
          ip_range = ip_rule.value.ip_range
        }
      }
      dynamic "virtual_network" {
        for_each = try(network_rule_set.value.virtual_networks, {})

        content {
          action    = "Allow"
          subnet_id = can(virtual_network.value.subnet_id) ? virtual_network.value.subnet_id : var.vnets[try(virtual_network.value.lz_key, var.client_config.landingzone_key)][virtual_network.value.vnet_key].subnets[virtual_network.value.subnet_key].id
        }
      }
    }
  }

  public_network_access_enabled = var.public_network_access_enabled
  quarantine_policy_enabled     = try(var.settings.quarantine_policy_enabled, null)
  retention_policy              = try(var.settings.retention_policy, null)

  trust_policy {
    enabled = try(var.settings.trust_policy.enabled, false)
  }

  zone_redundancy_enabled = try(var.settings.zone_redundancy_enabled, false)
  export_policy_enabled   = try(var.settings.export_policy_enabled, true)

  dynamic "identity" {
    for_each = can(var.settings.identity) ? [1] : []

    content {
      type         = try(var.settings.identity.type, null)
      identity_ids = try(local.identity_ids, null)
    }
  }

  dynamic "encryption" {
    for_each = can(var.settings.encryption) ? [1] : []

    content {
      enabled            = try(var.settings.encryption.enabled, null)
      key_vault_key_id   = try(var.remote_objects.keyvault_keys[try(var.settings.encryption.keyvault_key.lz_key, var.client_config.landingzone_key, null)][try(var.settings.encryption.keyvault_key_key, var.settings.encryption.keyvault_key.key)].id)
      identity_client_id = try(var.remote_objects.managed_identities[try(var.settings.identity.lz_key, var.client_config.landingzone_key, null)][try(var.settings.identity.key, var.settings.identity_key)].id)

    }
  }

  anonymous_pull_enabled     = try(var.settings.anonymous_pull_enabled, null)
  data_endpoint_enabled      = try(var.settings.data_endpoint_enabled, null)
  network_rule_bypass_option = try(var.settings.network_rule_bypass_option, null)
}

