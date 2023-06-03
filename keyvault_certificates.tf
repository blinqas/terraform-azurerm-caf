module "keyvault_certificates" {
  source     = "./modules/security/keyvault_certificate"
  depends_on = [module.keyvaults, module.keyvault_access_policies]

  for_each = local.security.keyvault_certificates

  settings = each.value  
  keyvault = local.combined_objects_keyvaults[try(each.value.keyvault.lz_key, each.value.lz_key, local.client_config.landingzone_key)][try(each.value.keyvault.key, each.value.keyvault_key)]

  subject_alternative_names = {
    dns_names = try(each.value.subject_alternative_names.dns_names, [])
    emails    = try(each.value.subject_alternative_names.emails, [])
    upns      = try(each.value.subject_alternative_names.upns, [])
  }
}

output "keyvault_certificates" {
  value = module.keyvault_certificates
}