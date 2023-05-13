azurerm_iothub_route = {
  example_route = {
    name = "test-name"
    resource_group = {
      lz_key = "lz1"
      key = "rg_test"      
    }
    # iothub_name also supported
    iothub = {
      lz_key = "lz2"
      key = "iothub_test"
    }
    source = "DeviceConnectionStateEvents" # Allowed values: DeviceConnectionStateEvents, DeviceJobLifecycleEvents, DeviceLifecycleEvents, DeviceMessages, DigitalTwinChangeEvents, Invalid, TwinChangeEvents
    condition = "SELECT properties.reported.telemetryConfig.status AS status, COUNT() AS numberOfDevices FROM devices GROUP BY properties.reported.telemetryConfig.status"
    # endpoint_names also supported, only one endpoint is allowed currently.
    endpoints = {
      default = {  # Currently only one endpoint is allowed.
        lz_key = "lz3"
        key = "endpoint_test"
      }      
    }
    enabled = true # False
  }
}