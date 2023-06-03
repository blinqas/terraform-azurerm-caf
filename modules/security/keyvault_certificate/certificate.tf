locals {
  san = var.subject_alternative_names != null ? {
    dns_names = length(var.subject_alternative_names.dns_names) > 0 ? var.subject_alternative_names.dns_names : null
    emails    = length(var.subject_alternative_names.emails) > 0 ? var.subject_alternative_names.emails : null
    upns      = length(var.subject_alternative_names.upns) > 0 ? var.subject_alternative_names.upns : null
  } : null
}

resource "azurerm_key_vault_certificate" "cert" {

  name         = var.settings.name
  key_vault_id = var.keyvault.id
  # Disabled inherited tags as it may have exceed limit of 15 tags on cert that gives badparameter error
  tags = try(var.settings.cert_tags, {})

  certificate_policy {
    issuer_parameters {
      name = var.settings.issuer_parameters
    }

    key_properties {
      curve      = var.settings.curve
      exportable = var.settings.exportable
      key_size   = var.settings.key_size
      key_type   = var.settings.key_type
      reuse_key  = var.settings.reuse_key
    }

    lifetime_action {
      action {
        action_type = var.settings.action_type
      }

      trigger {
        days_before_expiry  = try(var.settings.lifetime_percentage, null) == null ? var.settings.days_before_expiry : "0"
        lifetime_percentage = try(var.settings.days_before_expiry, null) == null ? var.settings.lifetime_percentage : "0"
      }
    }

    secret_properties {
      content_type = var.settings.content_type
    }

    x509_certificate_properties {
      extended_key_usage = var.settings.extended_key_usage
      key_usage          = var.settings.key_usage

      subject            = var.settings.subject
      validity_in_months = var.settings.validity_in_months

      dynamic "subject_alternative_names" {
        for_each = local.san != null ? [local.san] : []
        content {
          dns_names = var.subject_alternative_names.dns_names
          emails    = var.subject_alternative_names.emails
          upns      = var.subject_alternative_names.upns
        }
      }
    }

  }
}
