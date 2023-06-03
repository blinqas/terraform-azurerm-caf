locals {
  # Need to update the storage tags if the environment tag is updated with the rover command line
  tags = lookup(var.storage_account, "tags", null) == null ? null : lookup(var.storage_account.tags, "environment", null) == null ? var.storage_account.tags : merge(lookup(var.storage_account, "tags", {}), { "environment" : var.global_settings.environment })
}

# naming convention. Updated to support resource spesific overrides of azurecaf properties.
resource "azurecaf_name" "stg" {
  name          = var.storage_account.name
  resource_type = "azurerm_storage_account"
  prefixes      = try(var.storage_account.azurecaf.prefixes, var.global_settings.prefixes)
  random_length = try(var.storage_account.azurecaf.random_length, var.global_settings.random_length)
  clean_input   = true
  passthrough   = try(var.storage_account.azurecaf.passthrough, var.global_settings.passthrough)
  use_slug      = try(var.storage_account.azurecaf.use_slug, var.global_settings.use_slug)
}

# Tested with :  AzureRM version 3.45
# Ref : https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account

resource "azurerm_storage_account" "stg" {
  name                             = azurecaf_name.stg.result
  resource_group_name              = var.resource_group_name
  location                         = var.location
  account_kind                     = try(var.storage_account.account_kind, "StorageV2")
  account_tier                     = try(var.storage_account.account_tier, "Standard")
  account_replication_type         = try(var.storage_account.account_replication_type, "LRS")
  cross_tenant_replication_enabled = try(var.storage_account.cross_tenant_replication_enabled, true)
  access_tier                      = try(var.storage_account.access_tier, "Hot")
  edge_zone                        = try(var.storage_account.edge_zone, null)
  enable_https_traffic_only        = try(var.storage_account.enable_https_traffic_only, true)
  min_tls_version                  = try(var.storage_account.min_tls_version, "TLS1_2")
  allow_nested_items_to_be_public  = try(var.storage_account.allow_nested_items_to_be_public, true)
  shared_access_key_enabled        = try(var.storage_account.shared_access_key_enabled, true)
  public_network_access_enabled    = try(var.storage_account.public_network_access_enabled, var.storage_account.allow_blob_public_access, false)
  default_to_oauth_authentication  = try(var.storage_account.default_to_oauth_authentication, false)
  is_hns_enabled                   = try(var.storage_account.is_hns_enabled, false)
  nfsv3_enabled                    = try(var.storage_account.nfsv3_enabled, false)

  dynamic "custom_domain" {
    for_each = can(var.storage_account.custom_domain) ? [1] : []

    content {
      name          = var.storage_account.custom_domain.name
      use_subdomain = try(var.storage_account.custom_domain.use_subdomain, null)
    }
  }

  # blinQ: legacy by caf implementation - dedicated resource in terraform azurerm 3.47
  /*dynamic "customer_managed_key" {
    for_each = can(var.storage_account.customer_managed_key) ? [1] : []

    content {
      key_vault_key_id          = var.storage_account.customer_managed_key.key_vault_key_id                     # Update root module
      user_assigned_identity_id = try(var.storage_account.customer_managed_key.user_assigned_identity_id, null) # Update root module
    }
  }
  */

  dynamic "identity" {
    for_each = can(var.storage_account.identity) ? [var.storage_account.identity] : []

    content {
      type         = identity.value.type
      identity_ids = local.managed_identities
    }
  }

  dynamic "blob_properties" {
    for_each = can(var.storage_account.blob_properties) ? [1] : []

    content {

      dynamic "cors_rule" {
        for_each = can(var.storage_account.blob_properties.cors_rule) ? [1] : []

        content {
          allowed_headers    = try(var.storage_account.blob_properties.cors_rule.allowed_headers, null)
          allowed_methods    = try(var.storage_account.blob_properties.cors_rule.allowed_methods, null)
          allowed_origins    = try(var.storage_account.blob_properties.cors_rule.allowed_origins, null)
          exposed_headers    = try(var.storage_account.blob_properties.cors_rule.exposed_headers, null)
          max_age_in_seconds = try(var.storage_account.blob_properties.cors_rule.max_age_in_seconds, null)
        }
      }

      dynamic "delete_retention_policy" {
        for_each = can(var.storage_account.blob_properties.delete_retention_policy) ? [1] : []

        content {
          days = try(var.storage_account.blob_properties.delete_retention_policy.days, null)
        }
      }

      dynamic "restore_policy" {
        for_each = (can(var.storage_account.blob_properties.restore_policy) &&
          can(var.storage_account.blob_properties.delete_retention_policy.days) &&
        var.storage_account.blob_properties.versioning_enabled) ? [1] : []

        content {
          days = try(var.storage_account.blob_properties.restore_policy.days, null)
        }
      }

      versioning_enabled            = try(var.storage_account.blob_properties.versioning_enabled, false)
      change_feed_enabled           = try(var.storage_account.blob_properties.change_feed_enabled, false)
      change_feed_retention_in_days = try(var.storage_account.blob_properties.change_feed_retention_in_days, null)
      default_service_version       = try(var.storage_account.blob_properties.default_service_version, null)
      last_access_time_enabled      = try(var.storage_account.blob_properties.last_access_time_enabled, false)

      dynamic "container_delete_retention_policy" {
        for_each = can(var.storage_account.blob_properties.container_delete_retention_policy) ? [1] : []

        content {
          days = try(var.storage_account.blob_properties.container_delete_retention_policy.days, null)
        }
      }

    }
  }

  dynamic "queue_properties" {
    for_each = can(var.storage_account.queue_properties) ? [1] : []

    content {
      dynamic "cors_rule" {
        for_each = can(var.storage_account.queue_properties.cors_rule) ? [1] : []

        content {
          allowed_headers    = try(var.storage_account.queue_properties.cors_rule.allowed_headers, null)
          allowed_methods    = try(var.storage_account.queue_properties.cors_rule.allowed_methods, null)
          allowed_origins    = try(var.storage_account.queue_properties.cors_rule.allowed_origins, null)
          exposed_headers    = try(var.storage_account.queue_properties.cors_rule.exposed_headers, null)
          max_age_in_seconds = try(var.storage_account.queue_properties.cors_rule.max_age_in_seconds, null)
        }
      }

      dynamic "logging" {
        for_each = can(var.storage_account.queue_properties.logging) ? [1] : []

        content {
          delete                = try(var.storage_account.queue_properties.logging.delete, null)
          read                  = try(var.storage_account.queue_properties.logging.read, null)
          version               = try(var.storage_account.queue_properties.logging.version, null)
          write                 = try(var.storage_account.queue_properties.logging.write, null)
          retention_policy_days = try(var.storage_account.queue_properties.logging.retention_policy_days, null)
        }
      }

      dynamic "minute_metrics" {
        for_each = can(var.storage_account.queue_properties.minute_metrics) ? [1] : []

        content {
          enabled               = try(var.storage_account.queue_properties.minute_metrics.enabled, null)
          version               = try(var.storage_account.queue_properties.minute_metrics.version, null)
          include_apis          = try(var.storage_account.queue_properties.minute_metrics.include_apis, null)
          retention_policy_days = try(var.storage_account.queue_properties.minute_metrics.retention_policy_days, null)
        }
      }

      dynamic "hour_metrics" {
        for_each = can(var.storage_account.queue_properties.hour_metrics) ? [1] : []

        content {
          enabled               = try(var.storage_account.queue_properties.hour_metrics.enabled, null)
          version               = try(var.storage_account.queue_properties.hour_metrics.version, null)
          include_apis          = try(var.storage_account.queue_properties.hour_metrics.include_apis, null)
          retention_policy_days = try(var.storage_account.queue_properties.hour_metrics.retention_policy_days, null)
        }
      }
    }
  }

  # --------------- above updated according to 3.44.1 documentation

  infrastructure_encryption_enabled = try(var.storage_account.infrastructure_encryption_enabled, null)
  large_file_share_enabled          = try(var.storage_account.large_file_share_enabled, null)
  queue_encryption_key_type         = try(var.storage_account.queue_encryption_key_type, null)
  table_encryption_key_type         = try(var.storage_account.table_encryption_key_type, null)
  tags                              = merge(var.base_tags, local.tags)


  dynamic "static_website" {
    for_each = lookup(var.storage_account, "static_website", false) == false ? [] : [1]

    content {
      index_document     = try(var.storage_account.static_website.index_document, null)
      error_404_document = try(var.storage_account.static_website.error_404_document, null)
    }
  }

  dynamic "network_rules" {
    for_each = lookup(var.storage_account, "network", null) == null ? [] : [1]
    content {
      bypass         = try(var.storage_account.network.bypass, [])
      default_action = try(var.storage_account.network.default_action, "Deny")
      ip_rules       = try(var.storage_account.network.ip_rules, [])
      virtual_network_subnet_ids = try(var.storage_account.network.subnets, null) == null ? null : [
        for key, value in var.storage_account.network.subnets : can(value.remote_subnet_id) ? value.remote_subnet_id : var.vnets[try(value.lz_key, var.client_config.landingzone_key)][value.vnet_key].subnets[value.subnet_key].id
      ]
    }
  }

  dynamic "azure_files_authentication" {
    for_each = lookup(var.storage_account, "azure_files_authentication", false) == false ? [] : [1]

    content {
      directory_type = var.storage_account.azure_files_authentication.directory_type

      dynamic "active_directory" {
        for_each = lookup(var.storage_account.azure_files_authentication, "active_directory", false) == false ? [] : [1]

        content {
          storage_sid         = var.storage_account.azure_files_authentication.active_directory.storage_sid
          domain_name         = var.storage_account.azure_files_authentication.active_directory.domain_name
          domain_sid          = var.storage_account.azure_files_authentication.active_directory.domain_sid
          domain_guid         = var.storage_account.azure_files_authentication.active_directory.domain_guid
          forest_name         = var.storage_account.azure_files_authentication.active_directory.forest_name
          netbios_domain_name = var.storage_account.azure_files_authentication.active_directory.netbios_domain_name
        }
      }
    }
  }

  dynamic "routing" {
    for_each = lookup(var.storage_account, "routing", false) == false ? [] : [1]

    content {
      publish_internet_endpoints  = try(var.storage_account.routing.publish_internet_endpoints, false)
      publish_microsoft_endpoints = try(var.storage_account.routing.publish_microsoft_endpoints, false)
      choice                      = try(var.storage_account.routing.choice, "MicrosoftRouting")
    }
  }

  lifecycle {
    ignore_changes = [
      location,
      resource_group_name,
      customer_managed_key
    ]
  }
}

module "queue" {
  source   = "./queue"
  for_each = try(var.storage_account.queues, {})

  storage_account_name = azurerm_storage_account.stg.name
  settings             = each.value
}

module "container" {
  source   = "./container"
  for_each = try(var.storage_account.containers, {})

  storage_account_name = azurerm_storage_account.stg.name
  settings             = each.value
}

module "data_lake_filesystem" {
  source   = "./data_lake_filesystem"
  for_each = try(var.storage_account.data_lake_filesystems, {})

  storage_account_id = azurerm_storage_account.stg.id
  settings           = each.value
}

module "file_share" {
  source     = "./file_share"
  for_each   = try(var.storage_account.file_shares, {})
  depends_on = [azurerm_backup_container_storage_account.container]

  storage_account_name = azurerm_storage_account.stg.name
  storage_account_id   = azurerm_storage_account.stg.id
  settings             = each.value
  recovery_vault       = local.recovery_vault
  resource_group_name  = var.resource_group_name
}

module "management_policy" {
  source             = "./management_policy"
  for_each           = try(var.storage_account.management_policies, {})
  storage_account_id = azurerm_storage_account.stg.id
  settings           = try(var.storage_account.management_policies, {})
}
