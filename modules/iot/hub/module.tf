
# naming convention
resource "azurecaf_name" "iothub" {
  name          = var.name
  resource_type = "azurerm_iothub"
  prefixes      = var.global_settings.prefixes
  random_length = var.global_settings.random_length
  clean_input   = true
  passthrough   = var.global_settings.passthrough
  use_slug      = var.global_settings.use_slug
}

resource "azurerm_iothub" "iothub" {
  name                = azurecaf_name.iothub.result
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = local.tags

  sku {
    name     = var.settings.sku.name
    capacity = var.settings.sku.capacity
  }

  event_hub_partition_count     = try(var.settings.event_hub_partition_count, null)
  event_hub_retention_in_days   = try(var.settings.event_hub_retention_in_days, null)
  public_network_access_enabled = try(var.settings.public_network_access_enabled, null)
  min_tls_version               = try(var.settings.min_tls_version, null)

  dynamic "identity" {
    for_each = can(var.settings.identity.identity_ids) ? [1] : []

    content {
      type         = try(local.identity.type, null)
      identity_ids = try(local.identity_ids, [])
      # try(var.remote_objects.managed_identities[try(local.identity.lz_key, var.client_config.landingzone_key)][local.identity.key].id, null)
    }
  }

  dynamic "file_upload" {
    for_each = can(var.settings.file_upload.container_name) ? [1] : []

    content {
      authentication_type = try(local.file_upload.authentication_type, null)
      identity_id         = can(local.file_upload.identity.identity_id.id) ? local.file_upload.identity.identity_id.id : try(var.remote_objects.managed_identities[try(local.file_upload.identity.lz_key, var.client_config.landingzone_key)][local.file_upload.identity.key].id, null)
      connection_string   = can(local.file_upload.connection_string.id) ? local.file_upload.connection_string.id : can(local.file_upload.connection_string.storage_account_key) ? var.remote_objects.storage_accounts[try(local.file_upload.connection_string.lz_key, var.client_config.landingzone_key)][local.file_upload.connection_string.storage_account_key].primary_connection_string : null

      container_name     = try(local.file_upload.container_name, null)
      sas_ttl            = try(local.file_upload.sas_ttl, null)
      notifications      = try(local.file_upload.notifications, null)
      lock_duration      = try(local.file_upload.lock_duration, null)
      default_ttl        = try(local.file_upload.default_ttl, null)
      max_delivery_count = try(local.file_upload.max_delivery_count, null)
    }
  }

  dynamic "cloud_to_device" {
    for_each = can(var.settings.cloud_to_device) ? [1] : [0]

    content {
      max_delivery_count = try(local.cloud_to_device.max_delivery_count, null)
      default_ttl        = try(local.cloud_to_device.default_ttl, null)

      dynamic "feedback" {
        for_each = local.feedback
        content {
          time_to_live       = try(local.feedback.time_to_live, null)
          max_delivery_count = try(local.feedback.max_delivery_count, null)
          lock_duration      = try(local.feedback.lock_duration, null)
        }
      }
    }
  }

  dynamic "network_rule_set" {
    for_each = can(local.network_rule_set) ? [1] : []

    content {
      default_action                     = try(network_rule_set.default_action, null)
      apply_to_builtin_eventhub_endpoint = try(network_rule_set.apply_to_builtin_eventhub_endpoint, null)

      dynamic "ip_rule" {
        for_each = { for k, v in local.ip_rules : k => v }

        content {
          name    = try(ip_rule.value.name, null)
          ip_mask = try(ip_rule.value.ip_mask, null)
          action  = try(ip_rule.value.action, null)
        }
      }
    }
  }
}
