## naming convention
resource "azurecaf_name" "route_map" {
  name          = var.name
  resource_type = "azurerm_virtual_hub" # azurerm_route_map
  prefixes      = var.global_settings.prefixes
  random_length = var.global_settings.random_length
  clean_input   = true
  passthrough   = var.global_settings.passthrough
  use_slug      = var.global_settings.use_slug
}

resource "azurerm_route_map" "route_map" {
  name = azurecaf_name.route_map.result

  virtual_hub_id = var.virtual_hubs[try(var.settings.virtual_hub.lz_key, var.client_config.landingzone_key)][var.settings.virtual_hub.key].id

  dynamic "rule" {
    for_each = var.settings.rules

    content {
      name = rule.value.name

      dynamic "action" {
        for_each = can(rule.value.action) ? [1] : []

        content {
          type = rule.value.action.type

          parameter {
            as_path      = try(rule.value.action.parameter.as_path, [])
            community    = try(rule.value.action.parameter.community, [])
            route_prefix = try(rule.value.action.parameter.route_prefix, [])
          }
        }
      }

      dynamic "match_criterion" {
        for_each = can(rule.value.match_criterion) ? [1] : []

        content {
          match_condition = try(rule.value.match_criterion.match_condition, null)
          as_path         = try(rule.value.match_criterion.as_path, null)
          community       = try(rule.value.match_criterion.community, null)
          route_prefix    = try(rule.value.match_criterion.route_prefix, null)
        }
      }

      next_step_if_matched = try(rule.value.next_step_if_matched, "Unknown")
    }
  }
}
