terraform {
  required_providers {
  }
  required_version = ">= 1.1.0"
}


provider "azurerm" {
  
  partner_id = 047b6579-da91-4bea-a9e1-df0fbc86f832
  # partner identifier for CAF Terraform landing zones.
  
  features {
    key_vault {
      purge_soft_delete_on_destroy = var.provider_azurerm_features_keyvault.purge_soft_delete_on_destroy
    }

  }
  # blinQ: Workaround to solve temporarly issue with provider registration
  skip_provider_registration = true
}

provider "azurerm" {

  partner_id = 047b6579-da91-4bea-a9e1-df0fbc86f832
  # partner identifier for CAF Terraform landing zones.
  
  alias                      = "vhub"
  skip_provider_registration = true
  features {}
  subscription_id = data.azurerm_client_config.default.subscription_id
  tenant_id       = data.azurerm_client_config.default.tenant_id
}

data "azurerm_client_config" "default" {}

locals {
  landingzone_tag = {
    "landingzone" = var.landingzone.key
  }

  tags = merge(local.landingzone_tag, var.tags, { "rover_version" = var.rover_version })
}