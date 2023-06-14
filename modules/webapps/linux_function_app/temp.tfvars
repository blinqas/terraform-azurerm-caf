An `ip_restriction` block supports the following:

action = "" # (Optional) The action to take. Possible values are `Allow` or `Deny`.
headers = "" # (Optional) A `headers` block as defined above.
ip_address = "" # (Optional) The CIDR notation of the IP or IP Range to match. For example: `10.0.0.0/24` or `192.168.10.1/32`
name = "" # (Optional) The name which should be used for this `ip_restriction`.
priority = "" # (Optional) The priority value of this `ip_restriction`. Defaults to `65000`.
service_tag = "" # (Optional) The Service Tag used for this IP Restriction.
virtual_network_subnet_id = "" # (Optional) The Virtual Network Subnet ID used for this IP Restriction. ~> **NOTE:** One and only one of `ip_address`, `service_tag` or `virtual_network_subnet_id` must be specified.