variable "global_settings" {
  description = "Global settings object (see module README.md)"
}

variable "tags" {
  description = "(Required) map of tags for the deployment"
}

variable "base_tags" {
  description = "Base tags for the resource to be inherited from the resource group."
  type        = map(any)
}

variable "name" {
  description = "(Required) Name of the App Service"
}

variable "location" {
  description = "(Required) Resource Location"
}

variable "resource_group_name" {
  description = "(Required) Resource group of the App Service"
}

variable "app_service_environment_id" {
  default = ""
}

variable "app_service_plan_id" {
  default = ""
}

variable "settings" {
}

