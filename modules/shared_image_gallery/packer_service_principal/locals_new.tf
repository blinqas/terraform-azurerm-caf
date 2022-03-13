locals {
  packer_template = {
    image_publisher        = try(var.settings.image_publisher, null)
    image_offer            = try(var.settings.image_offer, null)
    image_sku              = try(var.settings.image_sku, null)
    image_url              = try(var.settings.image_url, null)
    capture_container_name = try(var.settings.capture_container_name, null)
    capture_name_prefix    = try(var.settings.capture_name_prefix, null)
    # resource_group_name               = try(var.resource_group_name, null)
    storage_account = try(var.settings.storage_account, null)
  }
}
