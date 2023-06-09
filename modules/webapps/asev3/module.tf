resource "azurecaf_name" "asev3" {
  name          = var.settings.name
  resource_type = "azurerm_app_service_environment"
  prefixes      = var.global_settings.prefixes
  random_length = var.global_settings.random_length
  clean_input   = true
  passthrough   = var.global_settings.passthrough
  use_slug      = var.global_settings.use_slug
}

resource "azurerm_app_service_environment_v3" "asev3" {
  name                                   = azurecaf_name.asev3.result  
  resource_group_name                    = var.resource_group_name
  subnet_id                              = var.subnet_id
  allow_new_private_endpoint_connections = try(var.settings.allow_new_private_endpoint_connections, null)
  internal_load_balancing_mode           = try(var.settings.internal_load_balancing_mode, null)  
  dedicated_host_count                   = try(var.settings.dedicated_host_count, null)
  zone_redundant                         = try(var.settings.zone_redundant, null)
  tags                                   = try(local.tags, null)
  dynamic "cluster_setting" {
    for_each = can(var.settings.cluster_settings) ? var.settings.cluster_settings : {}

    content {
      name  = cluster_setting.value.name
      value = cluster_setting.value.value
    }
  }

  dynamic "cluster_setting" {
    for_each = can(var.settings.cluster_settings) ? [] : [1]

    content {
      name  = "FrontEndSSLCipherSuiteOrder"
      value = "TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384,TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256"
    }
  }
}

/* blinQ todo: we need to add some new properties to this module
type AppServiceEnvironmentV3Model struct {
	Name                               string                            `tfschema:"name"`
	ResourceGroup                      string                            `tfschema:"resource_group_name"`
	SubnetId                           string                            `tfschema:"subnet_id"`
	AllowNewPrivateEndpointConnections bool                              `tfschema:"allow_new_private_endpoint_connections"`
	ClusterSetting                     []ClusterSettingModel             `tfschema:"cluster_setting"`
	DedicatedHostCount                 int                               `tfschema:"dedicated_host_count"`
	InternalLoadBalancingMode          string                            `tfschema:"internal_load_balancing_mode"`
	ZoneRedundant                      bool                              `tfschema:"zone_redundant"`
	Tags                               map[string]string                 `tfschema:"tags"`
	DnsSuffix                          string                            `tfschema:"dns_suffix"`
	ExternalInboundIPAddresses         []string                          `tfschema:"external_inbound_ip_addresses"`
	InboundNetworkDependencies         []AppServiceV3InboundDependencies `tfschema:"inbound_network_dependencies"`
	InternalInboundIPAddresses         []string                          `tfschema:"internal_inbound_ip_addresses"`
	IpSSLAddressCount                  int                               `tfschema:"ip_ssl_address_count"`
	LinuxOutboundIPAddresses           []string                          `tfschema:"linux_outbound_ip_addresses"`
	Location                           string                            `tfschema:"location"`
	PricingTier                        string                            `tfschema:"pricing_tier"`
	WindowsOutboundIPAddresses         []string                          `tfschema:"windows_outbound_ip_addresses"`
  */
