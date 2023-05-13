azurerm_iothub_route = {
  example_route = {
    name = "test-name"
    resource_group = {
      lz_key = "lz1"
      key = "rg_test"      
    }
    iothub = {
      lz_key = "lz2"
      key = "iothub_test"
    }
    source = "DeviceConnectionStateEvents" # Allowed values: DeviceConnectionStateEvents, DeviceJobLifecycleEvents, DeviceLifecycleEvents, DeviceMessages, DigitalTwinChangeEvents, Invalid, TwinChangeEvents
    condition = "SELECT properties.reported.telemetryConfig.status AS status, COUNT() AS numberOfDevices FROM devices GROUP BY properties.reported.telemetryConfig.status"
    endpoint_names = {
      lz_key = "lz3"
      key = "endpoint_test"
    }
    enabled = true # False
  }
}

name - (Required) The name of the route. Changing this forces a new resource to be created.

resource_group_name - (Required) The name of the resource group under which the IotHub Route resource has to be created. Changing this forces a new resource to be created.

iothub_name - (Required) The name of the IoTHub to which this Route belongs. Changing this forces a new resource to be created.

source - (Required) The source that the routing rule is to be applied to. Possible values include: DeviceConnectionStateEvents, DeviceJobLifecycleEvents, DeviceLifecycleEvents, DeviceMessages, DigitalTwinChangeEvents, Invalid, TwinChangeEvents.

condition - (Optional) The condition that is evaluated to apply the routing rule. If no condition is provided, it evaluates to true by default. For grammar, see: https://docs.microsoft.com/azure/iot-hub/iot-hub-devguide-query-language.

endpoint_names - (Required) The list of endpoints to which messages that satisfy the condition are routed. Currently only one endpoint is allowed.

enabled - (Required) Specifies whether a route is enabled.