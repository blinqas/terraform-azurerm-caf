#
# Managed identities from remote state
#

locals {
  // Adjusted to handle direct identity ID if provided 
  managed_direct_identity = try(var.settings.identity.id != null ? [var.settings.identity.id] : [], [])

  managed_local_identities = flatten([
    for managed_identity_key in try(var.settings.identity.managed_identity_keys, []) : [
      try(var.combined_resources.managed_identities[var.client_config.landingzone_key][managed_identity_key].id, null)
    ]
  ])

  managed_remote_identities = flatten([
    for lz_key, value in try(var.settings.identity.remote, []) : [
      for managed_identity_key in try(value.managed_identity_keys, []) : [
        try(var.combined_resources.managed_identities[lz_key][managed_identity_key].id, null)
      ]
    ]
  ])

  // Include the direct identity ID in the final list
  managed_identities = concat(local.managed_direct_identity, local.managed_local_identities, local.managed_remote_identities)
}

