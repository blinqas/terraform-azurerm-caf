linux_function_apps = {
  example = {
    name = "example"
    # region = "region1"

    # resource_group_name = ""
    # resource_group_key = ""
    resource_group = {
      lz_key = ""
      key    = ""
      # name = ""
    }

    # service_plan_key = ""
    # service_plan_id = ""
    service_plan = {
      lz_key = ""
      key    = ""
    }

    keyvault = {
      lz_key = ""
      key    = ""
    }

    site_config = {
      alway_on = true # (Optional) If this Linux Web App is Always On enabled. Defaults to `false`.
      api_definition_url                     = ""   # (Optional) The URL of the API definition that describes this Linux Function App

      api_management_api = {
        # (Optional) The ID of the API Management API for this Linux Function App
        # id = ""
        lz_key = ""
        key    = ""
      }

      app_command_line                       = ""   # (Optional) App command line to launch
      app_scale_limit = "3" # (Optional) The number of workers this function app can scale out to. Only applicable to apps on the Consumption and Premium plan

      application_insights_key = ""   # (Optional) The Instrumentation Key for connecting the Linux Function App to Application Insights.
      application_insights = {
        lz_key = ""
        key = ""      
        # application_insights_connection_string = ""   # (Optional) The Connection String for linking the Linux Function App to Application Insights.
        # application_insights_key               = ""   # (Optional) The Instrumentation Key for connecting the Linux Function App to Application Insights.
      }

      application_stack = {
        # (Optional) An `application_stack` block as defined above. ~> **Note:** If this is set, there must not be an application setting `FUNCTIONS_WORKER_RUNTIME`.

        docker = {
          # (Optional) One or more `docker` blocks as defined below.
          registry_url      = "" # (Required) The URL of the docker registry.
          image_name        = "" # (Required) The name of the Docker image to use.
          image_tag         = "" # (Required) The image tag of the image to use.
          registry_username = "" # (Optional) The username to use for connections to the registry. ~> **NOTE:** This value is required if `container_registry_use_managed_identity` is not set to `true`.
          registry_password = "" # (Optional) The password for the account to use to connect to the registry. ~> **NOTE:** This value is required if `container_registry_use_managed_identity` is not set to `true`.
        }

        dotnet_version              = "7.0"  # (Optional) The version of .NET to use. Possible values include `3.1`, `6.0` and `7.0`.
        use_dotnet_isolated_runtime = "true" # (Optional) Should the DotNet process use an isolated runtime. Defaults to `false`.
        java_version                = "17"   # (Optional) The Version of Java to use. Supported versions include `8`, `11` & `17`.
        node_version                = "18"   # (Optional) The version of Node to run. Possible values include `12`, `14`, `16` and `18`.
        python_version              = "3.7"  # (Optional) The version of Python to run. Possible values are `3.11`, `3.10`, `3.9`, `3.8` and `3.7`.
        powershell_core_version     = "7.2"  # (Optional) The version of PowerShell Core to run. Possible values are `7`, and `7.2`.
        use_custom_runtime          = false  # (Optional) Should the Linux Function App use a custom runtime?
      }

      app_service_logs = {
        # (Optional) An `app_service_logs` block as defined above.
        disk_quota_mb         = "100" # (Optional) The amount of disk space to use for logs. Valid values are between `25` and `100`. Defaults to `35`.
        retention_period_days = "90"  # (Optional) The retention period for logs in days. Valid values are between `0` and `99999`.(never delete). ~> **NOTE:** This block is not supported on Consumption plans.
      }
      container_registry_use_managed_identity = true # (Optional) Should connections for Azure Container Registry use Managed Identity.
      container_registry_managed_identity = {
        lz_key                                        = ""
        key                                           = ""
        container_registry_managed_identity_client_id = "" # (Optional) The Client ID of the Managed Service Identity to use for connections to the Azure Container Registry.
      }
      cors = {
        # (Optional) A `cors` block as defined above.
        allowed_origins     = ""    # (Required) Specifies a list of origins that should be allowed to make cross-origin calls.
        support_credentials = false # (Optional) Are credentials allowed in CORS requests? Defaults to `false`.
      }
      default_documents                             = [""]   # (Optional) Specifies a list of Default Documents for the Linux Web App.
      elastic_instance_minimum                      = "3"   # (Optional) The number of minimum instances for this Linux Function App. Only affects apps on Elastic Premium plans.
      ftps_state = "Disabled" # (Optional) State of FTP / FTPS service for this function app. Possible values include: `AllAllowed`, `FtpsOnly` and `Disabled`. Defaults to `Disabled`.
      health_check_path                             = "/healthcheck"   # (Optional) The path to be checked for this function app health.
      health_check_eviction_time_in_min             = "2"   # (Optional) The amount of time in minutes that a node can be unhealthy before being removed from the load balancer. Possible values are between `2` and `10`. Only valid in conjunction with `health_check_path`.
      http2_enabled = true # (Optional) Specifies if the HTTP2 protocol should be enabled. Defaults to `false`.
      ip_restriction = {
        rule_one = {        
        # (Optional) One or more `ip_restriction` blocks as defined above.
        action                    = "" # (Optional) The action to take. Possible values are `Allow` or `Deny`.
        headers                   = "" # (Optional) A `headers` block as defined above.
        ip_address                = "" # (Optional) The CIDR notation of the IP or IP Range to match. For example: `10.0.0.0/24` or `192.168.10.1/32`
        name                      = "" # (Optional) The name which should be used for this `ip_restriction`.
        priority                  = "" # (Optional) The priority value of this `ip_restriction`. Defaults to `65000`.
        service_tag               = "" # (Optional) The Service Tag used for this IP Restriction.
        virtual_network_subnet_id = "" # (Optional) The Virtual Network Subnet ID used for this IP Restriction. ~> **NOTE:** One and only one of `ip_address`, `service_tag` or `virtual_network_subnet_id` must be specified.
        
        }
      }
      load_balancing_mode              = "" # (Optional) The Site load balancing mode. Possible values include: `WeightedRoundRobin`, `LeastRequests`, `LeastResponseTime`, `WeightedTotalTraffic`, `RequestHash`, `PerSiteRoundRobin`. Defaults to `LeastRequests` if omitted.
      managed_pipeline_mode            = "Integrated" # (Optional) Managed pipeline mode. Possible values include: `Integrated`, `Classic`. Defaults to `Integrated`.
      minimum_tls_version              = "1.2" # (Optional) The configures the minimum version of TLS required for SSL requests. Possible values include: `1.0`, `1.1`, and `1.2`. Defaults to `1.2`.
      pre_warmed_instance_count        = "1" # (Optional) The number of pre-warmed instances for this function app. Only affects apps on an Elastic Premium plan.
      remote_debugging_enabled         = false # (Optional) Should Remote Debugging be enabled. Defaults to `false`.
      remote_debugging_version         = null # (Optional) The Remote Debugging Version. Possible values include `VS2017`, `VS2019`, and `VS2022`.
      runtime_scale_monitoring_enabled = false # (Optional) Should Scale Monitoring of the Functions Runtime be enabled? ~> **NOTE:** Functions runtime scale monitoring can only be enabled for Elastic Premium Function Apps or Workflow Standard Logic Apps and requires a minimum prewarmed instance count of 1.
      scm_ip_restriction               = {
         # (Optional) One or more `scm_ip_restriction` blocks as defined above.
         action = "" # (Optional) The action to take. Possible values are `Allow` or `Deny`.
         headers = {
          header_one = {
            a_azure_fdid = [""] # (Optional) Specifies a list of Azure Front Door IDs.
            x_fd_health_probe = "1" # (Optional) Specifies if a Front Door Health Probe should be expected. The only possible value is 1.
            x_forwarder_for = [""] # (Optional) Specifies a list of addresses for which matching should be applied. Omitting this value means allow any.
            x_forwarded_host = [""] # (Optional) Specifies a list of Hosts for which matching should be applied.
          }
         }
      }
      scm_minimum_tls_version          = "" # (Optional) Configures the minimum version of TLS required for SSL requests to the SCM site Possible values include: `1.0`, `1.1`, and `1.2`. Defaults to `1.2`.
      scm_use_main_ip_restriction      = "" # (Optional) Should the Linux Function App `ip_restriction` configuration be used for the SCM also.
      use_32_bit_worker                = true # (Optional) Should the Linux Web App use a 32-bit worker process. Defaults to `true`.
      vnet_route_all_enabled           = false # (Optional) Should all outbound traffic to have NAT Gateways, Network Security Groups and User Defined Routes applied? Defaults to `false`.
      websockets_enabled               = "" # (Optional) Should Web Sockets be enabled. Defaults to `false`.
      worker_count                     = "" # (Optional) The number of Workers for this Linux Function App.
    }

    dynamic_app_settings = {
      /* (Optional) A map of key-value pairs for [App Settings](https://docs.microsoft.com/azure/azure-functions/functions-app-settings) and custom values.

        ~> **Note:** for runtime related settings, please use `node_version` in `site_config` to set the node version and use `functions_extension_version` to set the function runtime version, terraform will assign the values to the key `WEBSITE_NODE_DEFAULT_VERSION` and `FUNCTIONS_EXTENSION_VERSION` in app setting.
        ~> **Note:** For storage related settings, please use related properties that are available such as `storage_account_access_key`, terraform will assign the value to keys such as `WEBSITE_CONTENTAZUREFILECONNECTIONSTRING`, `AzureWebJobsStorage` in app_setting.
        ~> **Note:** for application insight related settings, please use `application_insights_connection_string` and `application_insights_key`, terraform will assign the value to the key `APPINSIGHTS_INSTRUMENTATIONKEY` and `APPLICATIONINSIGHTS_CONNECTION_STRING` in app setting.
        ~> **Note:** for health check related settings, please use `health_check_eviction_time_in_min`, terraform will assign the value to the key `WEBSITE_HEALTHCHECK_MAXPINGFAILURES` in app setting.
        ~> **NOTE:** Please create a predefined share if you are restricting your storage account to a virtual network by setting `WEBSITE_CONTENTOVERVNET` to 1 in app_setting.
        */
      "WEBSITE_NODE_DEFAULT_VERSION" = "10.14.1"
      "FUNCTIONS_WORKER_RUNTIME"     = "node"
    }

    # This example configuration use auth_settings_v2
    auth_settings = {
      enabled                        = false # (Required) Should the Authentication / Authorization feature be enabled for the Linux Web App?
      active_directory               = {
        # (Optional) An `active_directory` block as defined above.
        client_id                   = "" # (Required) The ID of the Client to use to authenticate with Azure Active Directory, client_id_kv_secret_key have Prsedence over client_id.        
        client_secret               = "" # (Optional) The Client Secret for the Client ID. Cannot be used with client_secret_setting_name, client_secret_settings_name have Prsedence over client_secret.
        client_secret_setting_name  = "" # (Optional) The App Setting name that contains the client secret of the Client, client_secret_kv_secret_key have Prsedence over client_secret_setting_name.
        allowed_audiences = "" # (Optional) Specifies a list of Allowed audience values to consider when validating JWTs issued by Azure Active Directory.
        lz_key = "" # Specifies the landingzone key where Azure Keyvault is located
        key = "" # Specifies the keyvault key name
        client_id_kv_secret_key = "" # (Optional) The keyvault secret key that contains the client id of the Client, client_id_kv_secret_key have Prsedence over client_id.
        client_secret_kv_secret_key = "" # (Optional) The keyvault secret key that contains the client secret of the Client, client_secret_kv_secret_key have Prsedence over client_secret. 
      }
      additional_login_parameters    = {""} # (Optional) Specifies a map of login Parameters to send to the OpenID Connect authorization endpoint when a user logs in.
      allowed_external_redirect_urls = [""] # (Optional) Specifies a list of External URLs that can be redirected to as part of logging in or logging out of the Linux Web App.
      default_provider               = "AzureActiveDirectory" # (Optional) The default authentication provider to use when multiple providers are configured. Possible values include: `AzureActiveDirectory`, `Facebook`, `Google`, `MicrosoftAccount`, `Twitter`, `Github` ~> **NOTE:** This setting is only needed if multiple providers are configured, and the `unauthenticated_client_action` is set to "RedirectToLoginPage".
      facebook = {
        # (Optional) A `facebook` block as defined below.
        app_id                   = "" # The App ID of the Facebook app used for login, app_id_kv_secret_key have Prsedence over app_id_setting_name.
        app_secret               = "" # (Optional) The App Secret of the Facebook app used for Facebook login. app_secret_kv_secret_key have Prsedence over app_secret_setting_name, who have Prsedence over app_secret.
        app_secret_setting_name  = "" # (Optional) The app setting name that contains the app_secret value used for Facebook login. Cannot be specified with app_secret or app_secret_kv_secret_key. Prsedence for this settings are app_secret_kv_secret_key > app_secret_setting_name > app_secret
        oauth_scopes             = "" # Specifies a list of OAuth 2.0 scopes to be requested as part of Facebook login authentication.
        lz_key                   = "" # Specifies the landingzone key where key vault is located.
        app_id_kv_secret_key     = "" # The key vault secret key that contains the app_id value used for Facebook login.
        app_secret_kv_secret_key = "" # The key vault secret key that contains the app_secret value used for Facebook login.
      }
      github = {
        # (Optional) A `github` block as defined below.
        client_id = "" # The Client ID of the GitHub app used for login, client_id_kv_secret_key have Prsedence over client_id_setting_name.
        client_secret = "" # The Client Secret of the GitHub app used for GitHub login. client_secret_kv_secret_key have Prsedence over client_secret_setting_name, who have Prsedence over client_secret.
        client_secret_setting_name = "" # The app setting name that contains the client_secret value used for GitHub login. Prsedence for this settings are client_secret_kv_secret_key > client_secret_setting_name > client_secret
        oauth_scopes = "" # Specifies a list of OAuth 2.0 scopes to be requested as part of GitHub login authentication.
        client_id_kv_secret_key = "" # The key vault secret key that contains the client_id value used for GitHub login.
        client_secret_kv_secret_key = "" # The key vault secret key that contains the client_secret value used for GitHub login.  
      }
      google                        = {
        # (Optional) A `google` block as defined below.
        client_id = "" # The Client ID of the Google app used for login, client_id_kv_secret_key have Prsedence over client_id_setting_name.
        client_secret = "" # The Client Secret of the Google app used for Google login. client_secret_kv_secret_key have Prsedence over client_secret_setting_name, who have Prsedence over client_secret.        
        client_secret_setting_name = "" # The app setting name that contains the client_secret value used for Google login. Prsedence for this settings are client_secret_kv_secret_key > client_secret_setting_name > client_secret
        oauth_scopes = "" # Specifies a list of OAuth 2.0 scopes to be requested as part of Google login authentication.
        client_id_kv_secret_key = "" # The key vault secret key that contains the client_id value used for Google login.
        client_secret_kv_secret_key = "" # The key vault secret key that contains the client_secret value used for Google login.
      }
      issuer                        = "" # (Optional) The OpenID Connect Issuer URI that represents the entity which issues access tokens for this Linux Web App. ~> **NOTE:** When using Azure Active Directory, this value is the URI of the directory tenant, e.g. <https://sts.windows.net/{tenant-guid}/>.
      microsoft                     = "" # (Optional) A `microsoft` block as defined below.
      runtime_version               = "" # (Optional) The RuntimeVersion of the Authentication / Authorization feature in use for the Linux Web App.
      token_refresh_extension_hours = "" # (Optional) The number of hours after session token expiration that a session token can be used to call the token refresh API. Defaults to `72` hours.
      token_store_enabled           = "" # (Optional) Should the Linux Web App durably store platform-specific security tokens that are obtained during login flows? Defaults to `false`.
      twitter                       = "" # (Optional) A `twitter` block as defined below.
      unauthenticated_client_action = "" # (Optional) The action to take when an unauthenticated client attempts to access the app. Possible values include: `RedirectToLoginPage`, `AllowAnonymous`.
    }

    auth_settings_v2 = {
      auth_enabled                            = true                   # (Optional) Should the AuthV2 Settings be enabled. Defaults to `false`.
      runtime_version                         = "~4"                   # (Optional) The Runtime Version of the Authentication and Authorisation feature of this App. Defaults to `~1`.
      config_file_path                        = null                   # (Optional) The path to the App Auth settings. * ~> **Note:** Relative Paths are evaluated from the Site Root directory.
      require_authentication                  = true                   # (Optional) Should the authentication flow be used for all requests.
      unauthenticated_action                  = "RedirectToLoginPage"  # (Optional) The action to take for requests made without authentication. Possible values include `RedirectToLoginPage`, `AllowAnonymous`, `Return401`, and `Return403`. Defaults to `RedirectToLoginPage`.
      default_provider                        = "azureactivedirectory" # (Optional) The Default Authentication Provider to use when the `unauthenticated_action` is set to `RedirectToLoginPage`. Possible values include: `apple`, `azureactivedirectory`, `facebook`, `github`, `google`, `twitter` and the `name` of your `custom_oidc_v2` provider. ~> **NOTE:** Whilst any value will be accepted by the API for `default_provider`, it can leave the app in an unusable state if this value does not correspond to the name of a known provider (either built-in value, or custom_oidc name) as it is used to build the auth endpoint URI.
      excluded_paths                          = null                   # (Optional) The paths which should be excluded from the `unauthenticated_action` when it is set to `RedirectToLoginPage`.
      require_https                           = true                   # (Optional) Should HTTPS be required on connections? Defaults to `true`.
      http_route_api_prefix                   = "/.auth"               # (Optional) The prefix that should precede all the authentication and authorisation paths. Defaults to `/.auth`.
      forward_proxy_convention                = null                   # (Optional) The convention used to determine the url of the request made. Possible values include `ForwardProxyConventionNoProxy`, `ForwardProxyConventionStandard`, `ForwardProxyConventionCustom`. Defaults to `ForwardProxyConventionNoProxy`.
      forward_proxy_custom_host_header_name   = null                   # (Optional) The name of the custom header containing the host of the request.
      forward_proxy_custom_scheme_header_name = null                   # (Optional) The name of the custom header containing the scheme of the request.
      apple_v2 = {
        # (Optional) An `apple_v2` block as defined below.
        client_id                   = "" # Use this or client_id_kv_key
        client_secret               = "" # client_secret as plain text, you should use client_secret_kv_key instead
        client_secret_setting_name  = "" # (Required) The app setting name that contains the `client_secret` value used for Apple Login. !> **NOTE:** A setting with this name must exist in `app_settings` to function correctly.
        lz_key                      = "" # Key Vault landingzone key
        key_vault_key               = "" # Key Vualt Key
        client_id_kv_secret_key     = "" # (Required) The Key Vault Key containing the OpenID Connect Client ID for the Apple web application.
        client_secret_kv_secret_key = "" # (Required) The Key Vault Key containing the OpenID Connect Client Secret for the Apple web application. Use this or the client_secret_setting_name.
        login_scopes                = "" # A list of Login Scopes provided by this Authentication Provider. ~> **NOTE:** This is configured on the Authentication Provider side and is Read Only here.
      }
      active_directory_v2 = {
        # (Optional) An `active_directory_v2` block as defined below.
        client_id = ""
        # (Required) The ID of the Client to use to authenticate with Azure Active Directory.
        # id =
        lz_key                               = ""
        key_vault_key                        = ""
        secret_key                           = ""
        tenant_auth_endpoint                 = ""   # (Required) The Azure Tenant Endpoint for the Authenticating Tenant. e.g. `https://login.microsoftonline.com/v2.0/{tenant-guid}/`
        client_secret_setting_name           = ""   # (Optional) The App Setting name that contains the client secret of the Client. !> **NOTE:** A setting with this name must exist in `app_settings` to function correctly.
        client_secret_certificate_thumbprint = ""   # (Optional) The thumbprint of the certificate used for signing purposes. ~> **NOTE:** One of `client_secret_setting_name` or `client_secret_certificate_thumbprint` must be specified.
        jwt_allowed_groups                   = [""] # (Optional) A list of Allowed Groups in the JWT Claim.
        jwt_allowed_client_applications      = [""] # (Optional) A list of Allowed Client Applications in the JWT Claim.
        www_authentication_disabled          = true # (Optional) Should the www-authenticate provider should be omitted from the request? Defaults to `false`
        allowed_groups                       = [""] # (Optional) The list of allowed Group Names for the Default Authorisation Policy.
        allowed_identities                   = [""] # (Optional) The list of allowed Identities for the Default Authorisation Policy.
        allowed_applications                 = [""] # (Optional) The list of allowed Applications for the Default Authorisation Policy.
        login_parameters                     = {}   # (Optional) A map of key-value pairs to send to the Authorisation Endpoint when a user logs in.
        allowed_audiences                    = [""] # (Optional) Specifies a list of Allowed audience values to consider when validating JWTs issued by Azure Active Directory. ~> **NOTE:** This is configured on the Authentication Provider side and is Read Only here.
      }
      azure_static_web_app_v2 = "" # (Optional) An `azure_static_web_app_v2` block as defined below.
      custom_oidc_v2          = "" # (Optional) Zero or more `custom_oidc_v2` blocks as defined below.
      facebook_v2             = "" # (Optional) A `facebook_v2` block as defined below.
      github_v2               = "" # (Optional) A `github_v2` block as defined below.
      google_v2               = "" # (Optional) A `google_v2` block as defined below.
      microsoft_v2            = "" # (Optional) A `microsoft_v2` block as defined below.
      twitter_v2              = "" # (Optional) A `twitter_v2` block as defined below.
      login                   = "" # (Optional) A `login` block as defined below.
    }

    backup = {
      name                = "" # (Required) The name which should be used for this Backup.
      schedule            = "" # (Required) A `schedule` block as defined below.
      storage_account_url = "" # (Required) The SAS URL to the container.
      enabled             = "" # (Optional) Should this backup job be enabled? Defaults to `true`.
    }

    builtin_logging_enabled            = true  # (Optional) Should the builtin logging be enabled? Defaults to `true`.
    client_certificate_enabled         = false # (Optional) Should the function app use Client Certificates.
    client_certificate_mode            = null  # (Optional) The mode of the Function App's client certificates requirement for incoming requests. Possible values are `Required`, `Optional`, and `OptionalInteractiveUser`.
    client_certificate_exclusion_paths = null  # (Optional) Paths to exclude when using client certificates, separated by ;

    connection_strings = {
      string_one = {
        # (Optional) One or more `connection_string` blocks as defined below.
        name  = "" # (Required) The name which should be used for this Connection.
        type  = "" # (Required) Type of database. Possible values include: `MySQL`, `SQLServer`, `SQLAzure`, `Custom`, `NotificationHub`, `ServiceBus`, `EventHub`, `APIHub`, `DocDb`, `RedisCache`, and `PostgreSQL`.
        value = "" # (Required) The connection string value.
      }
    }

    daily_memory_time_quota         = "0" # (Optional) The amount of memory in gigabyte-seconds that your application is allowed to consume per day. Setting this value only affects function apps under the consumption plan. Defaults to `0`.
    enabled                         = ""  # (Optional) Is the Function App enabled? Defaults to `true`.
    content_share_force_disabled    = ""  # (Optional) Should the settings for linking the Function App to storage be suppressed.
    functions_extension_version     = ""  # (Optional) The runtime version associated with the Function App. Defaults to `~4`.
    https_only                      = ""  # (Optional) Can the Function App only be accessed via HTTPS? Defaults to `false`.
    identity                        = ""  # (Optional) A `identity` block as defined below.
    key_vault_reference_identity_id = ""  # (Optional) The User Assigned Identity ID used for accessing KeyVault secrets. The identity must be assigned to the application in the `identity` block. [For more information see - Access vaults with a user-assigned identity](https://docs.microsoft.com/azure/app-service/app-service-key-vault-references#access-vaults-with-a-user-assigned-identity)
    storage_accounts = {
      # (Optional) One or more `storage_account` blocks as defined below.
      storage_one = {
        lz_key       = ""
        key          = ""
        access_key   = "" # (Required) The Access key for the storage account.
        account_name = "" # (Required) The Name of the Storage Account.
        name         = "" # (Required) The name which should be used for this Storage Account.
        share_name   = "" # (Required) The Name of the File Share or Container Name for Blob storage.
        type         = "" # (Required) The Azure Storage Type. Possible values include `AzureFiles` and `AzureBlob`.
        mount_path   = "" # (Optional) The path at which to mount the storage share.      
      }
    }
    sticky_settings = {
      # (Optional) A `sticky_settings` block as defined below.
      app_setting_names       = [""] # (Optional) A list of `app_setting` names that the Linux Function App will not swap between Slots when a swap operation is triggered.
      connection_string_names = [""] # (Optional) A list of `connection_string` names that the Linux Function App will not swap between Slots when a swap operation is triggered.
    }
    use_storage_account_access_key    = false # If true, CAF will read the access key from storage account module output. This be used to access the backend storage account for the Function App. Conflicts with `storage_uses_managed_identity`.
    storage_account_name          = "" # (Optional) The backend storage account name which will be used by this Function App.
    storage_uses_managed_identity = "" # (Optional) Should the Function App use Managed Identity to access the storage account. Conflicts with `storage_account_access_key`. ~> **NOTE:** One of `storage_account_access_key` or `storage_uses_managed_identity` must be specified when using `storage_account_name`.
    storage_key_vault_secret_id   = "" # (Optional) The Key Vault Secret ID, optionally including version, that contains the Connection String to connect to the storage account for this Function App. ~> **NOTE:*storage_key_vault_secret_id` cannot be used with `storage_account_name`. ~> **NOTE:*storage_key_vault_secret_id` used without a version will use the latest version of the secret, however, the service can take up to 24h to pick up a rotation of the latest version. See the [official docs](https://docs.microsoft.com/azure/app-service/app-service-key-vault-references#rotation) for more information.
    tags                          = "" # (Optional) A mapping of tags which should be assigned to the Linux Function App.
    virtual_network_subnet_id     = "" # (Optional) The subnet id which will be used by this Function App for [regional virtual network integration](https://docs.microsoft.com/en-us/azure/app-service/overview-vnet-integration#regional-virtual-network-integration). ~> **NOTE on regional virtual network integration:** The AzureRM Terraform provider provides regional virtual network integration via the standalone resource [app_service_virtual_network_swift_connection](app_service_virtual_network_swift_connection.html) and in-line within this resource using the `virtual_network_subnet_id` property. You cannot use both methods simultaneously. If the virtual network is set via the resource `app_service_virtual_network_swift_connection` then `ignore_changes` should be used in the function app configuration. ~> **Note:** Assigning the `virtual_network_subnet_id` property requires [RBAC permissions on the subnet](https://docs.microsoft.com/en-us/azure/app-service/overview-vnet-integration#permissions)
    zip_deploy_file               = "" # (Optional) The local path and filename of the Zip packaged application to deploy to this Linux Function App. ~> **Note:** Using this value requires either `WEBSITE_RUN_FROM_PACKAGE=1` or `SCM_DO_BUILD_DURING_DEPLOYMENT=true` to be set on the App in `app_settings`. Refer to the [Azure docs](https://learn.microsoft.com/en-us/azure/azure-functions/functions-deployment-technologies) for further details.

    active_directory = {
      client_id                  = "" # (Required) The ID of the Client to use to authenticate with Azure Active Directory.
      allowed_audiences          = "" # (Optional) Specifies a list of Allowed audience values to consider when validating JWTs issued by Azure Active Directory. ~> **Note:** The `client_id` value is always considered an allowed audience.
      client_secret              = "" # (Optional) The Client Secret for the Client ID. Cannot be used with `client_secret_setting_name`.
      client_secret_setting_name = "" # (Optional) The App Setting name that contains the client secret of the Client. Cannot be used with `client_secret`.
    }

  }
}

