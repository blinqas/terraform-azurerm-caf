locals {
  file_upload      = try(var.settings.file_upload, {})
  cloud_to_device  = try(var.settings.cloud_to_device, {})
  feedback         = try(local.cloud_to_device.feedback, {})
  identity         = try(var.settings.identity, {})
  network_rule_set = try(var.settings.network_rule_set, {})
  ip_rules          = try(local.network_rule_set.ip_rules, {})

  identity_ids = flatten(distinct(concat(
    [
      for key, value in local.identity.identity_ids : [
        for identity_key in try(value.keys, []) : var.remote_objects.managed_identities[try(key, var.client_config.landingzone_key)][identity_key].id
      ] if key != "keys" && key != "ids"
    ],
    [
      for keys in local.identity.identity_ids : [
        for identity_key in try(keys.keys, []) : var.remote_objects.managed_identities[try(var.client_config.landingzone_key)][identity_key].id
      ] if keys == "keys"
    ],
    try(local.identity.identity_ids.ids, [])
  )))
}