output "name" {
  value       = azurerm_iothub.iothub.name
}

output "resource_group_name" {
  value = azurerm_iothub.iothub.resource_group_name
}

output "location" {
  value = azurerm_iothub.iothub.location
}

output "sku" {
  value = azurerm_iothub.iothub.sku
}

output "event_hub_partition_count" {
  value = azurerm_iothub.iothub.event_hub_partition_count 
}

output "event_hub_retention_in_days" {
  value = azurerm_iothub.iothub.event_hub_retention_in_days
}

output "endpoint" {
  value = azurerm_iothub.iothub.endpoint
}

output "fallback_route" {
  value = azurerm_iothub.iothub.fallback_route
}

output "file_upload" {
  value = azurerm_iothub.iothub.file_upload
}

output "identity" {
  value = azurerm_iothub.iothub.identity
}

output "network_rule_set" {
  value = azurerm_iothub.iothub.network_rule_set
}

output "route" {
  value = azurerm_iothub.iothub.route
}

output "enrichment" {
  value = azurerm_iothub.iothub.enrichment
}

output "cloud_to_device" {
  value = azurerm_iothub.iothub.cloud_to_device
}

output "public_network_access_enabled" {
  value = azurerm_iothub.iothub.public_network_access_enabled
}

output "min_tls_version" {
  value = azurerm_iothub.iothub.min_tls_version
}

output "tags" {
  value = azurerm_iothub.iothub.tags
}

output "id" {
  value       = azurerm_iothub.iothub.id
}

output "event_hub_events_endpoint" {
  value       = azurerm_iothub.iothub.event_hub_events_endpoint
}

output "event_hub_events_namespace" {
  value       = azurerm_iothub.iothub.event_hub_events_namespace
}

output "event_hub_events_path" {
  value       = azurerm_iothub.iothub.event_hub_events_path
}

output "event_hub_operations_endpoint" {
  value       = azurerm_iothub.iothub.event_hub_operations_endpoint
}

output "event_hub_operations_path" {
  value       = azurerm_iothub.iothub.event_hub_operations_path 
}

output "hostname" {
  value       = azurerm_iothub.iothub.hostname 
}

output "shared_access_policy" {
  value       = azurerm_iothub.iothub.shared_access_policy
  sensitive = true 
}

