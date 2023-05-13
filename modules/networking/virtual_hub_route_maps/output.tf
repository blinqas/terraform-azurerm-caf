output "object" {
  description = "Full Virtual Hub Route Map Object"
  value       = azurerm_route_map.route_map
}

output "id" {
  description = "Resource ID of the Virtual Hub Route Map"
  value       = azurerm_route_map.route_map.id
}

output "name" {
  description = "Name of the Virtual Hub Route Map"
  value       = azurerm_route_map.route_map.name
}

output "virtual_hub_id" {
  description = "Virtual Hub Route Id that Route Map is related to"
  value       = azurerm_route_map.route_map.virtual_hub_id
}

output "rules" {
  description = "Virtual Hub Route Map Rules"
  value       = azurerm_route_map.route_map.rule
}

