variable "group_object_id" {}
variable "azuread_groups" {
  default = {}
}
variable "member_object_id" {
  default = null
}
variable "azuread_service_principals" {
  default = {}
}
variable "managed_identities" {
  default = {}
}
variable "members" {
  default = {}
}
variable "mssql_servers" {
  default = {}
}