output "name" {
  value       = azurerm_service_plan.service_plan.name
  description = "The name of the Service Plan."
}

output "location" {
  value       = azurerm_service_plan.service_plan.location
  description = "The Azure Region where the Service Plan exist."
}

output "os_type" {
  value       = azurerm_service_plan.service_plan.os_type
  description = "The O/S type for the App Services in this plan."
}

output "resource_group_name" {
  value       = azurerm_service_plan.service_plan.resource_group_name
  description = "The name of the Resource Group where the AppService exist."
}

output "sku_name" {
  value       = azurerm_service_plan.service_plan.sku_name
  description = "The SKU for the plan. Possible values include B1, B2, B3, D1, F1, I1, I2, I3, I1v2, I2v2, I3v2, I4v2, I5v2, I6v2, P1v2, P2v2, P3v2, P1v3, P2v3, P3v3, P1mv3, P2mv3, P3mv3, P4mv3, P5mv3, S1, S2, S3, SHARED, EP1, EP2, EP3, WS1, WS2, WS3, and Y1."
}

output "app_service_environment_id" {
  value       = try(azurerm_service_plan.service_plan.app_service_environment_id, null)
  description = "The ID of the App Service Environment wher this Service Plan is created."
}

output "maximum_elastic_worker_count" {
  value       = try(azurerm_service_plan.service_plan.maximum_elastic_worker_count, null)
  description = "The maximum number of workers to use in this Elastic SKU Plan."
}

output "worker_count" {
  value       = try(azurerm_service_plan.service_plan.worker_count, null)
  description = "The number of Workers (instances) to be allocated."
}

output "per_site_scaling_enabled" {
  value       = try(azurerm_service_plan.service_plan.per_site_scaling_enabled, null)
  description = "Per Site Scaling be enabled?"
}

output "zone_balancing_enabled" {
  value       = try(azurerm_service_plan.service_plan.zone_balancing_enabled, null)
  description = "Service Plan balance across Availability Zones in the region?"
}

output "id" {
  value       = azurerm_service_plan.service_plan.id
  description = "The ID of the Service Plan."
}

output "kind" {
  value       = azurerm_service_plan.service_plan.kind
  description = "A string representing the Kind of Service Plan."
}

output "reserved" {
  value       = azurerm_service_plan.service_plan.reserved
  description = "Whether this is a reserved Service Plan Type. true if os_type is Linux, otherwise false."
}