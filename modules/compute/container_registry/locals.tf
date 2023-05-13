/* htk blinq
locals {
  filtered_identities = {
    for identity_key, identities in var.remote_objects.managed_identities[var.settings.identities[*].lz_key] : identities => identities.id
  }

  identity_ids = [ for key, value in local.filtered_identities : value ]
}
    
*/