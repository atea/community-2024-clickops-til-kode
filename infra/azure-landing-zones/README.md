<!-- BEGIN_TF_DOCS -->
# Azure Landing Zones architecture

Denne mappen inneholder kode for å bygge en Azure Landing Zones-arkitektur med noen enkle tilpasninger ved å bruke Terraform-modulen [azurerm-caf-enterprise-scale](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale) og viser eksempler på hvordan man kan overstyre Azure Policy, legge til egne landingsone-typer og sette opp et Hub-Spoke nettverk.

<!-- markdownlint-disable MD033 -->
## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (~> 1.0)

- <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) (~> 2.0)

- <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) (~> 3.0)

## Resources

The following resources are used by this module:

- [azuread_group.community_demo_contributor](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/group) (resource)
- [azurerm_role_assignment.azure_landing_zones_contributor](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) (resource)
- [azuread_user.community_demo](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/user) (data source)
- [azuread_user.tjs](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/user) (data source)
- [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) (data source)

<!-- markdownlint-disable MD013 -->
## Required Inputs

The following input variables are required:

### <a name="input_connectivity_subscription_id"></a> [connectivity\_subscription\_id](#input\_connectivity\_subscription\_id)

Description: Azure subscription ID for connectivity resources

Type: `string`

### <a name="input_identity_subscription_id"></a> [identity\_subscription\_id](#input\_identity\_subscription\_id)

Description: Azure subscription ID for identity resources

Type: `string`

### <a name="input_management_subscription_id"></a> [management\_subscription\_id](#input\_management\_subscription\_id)

Description: Azure subscription ID for management resources

Type: `string`

### <a name="input_security_alerts_email_address"></a> [security\_alerts\_email\_address](#input\_security\_alerts\_email\_address)

Description: Email address for security alerts

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_connectivity_resources_location"></a> [connectivity\_resources\_location](#input\_connectivity\_resources\_location)

Description: Location for connectivity resources

Type: `string`

Default: `"westeurope"`

### <a name="input_connectivity_resources_tags"></a> [connectivity\_resources\_tags](#input\_connectivity\_resources\_tags)

Description: Default tags applied to all connectivity resources

Type: `map(string)`

Default:

```json
{
  "managed-by-terraform": "true"
}
```

### <a name="input_default_location"></a> [default\_location](#input\_default\_location)

Description: Default location for all resources

Type: `string`

Default: `"westeurope"`

### <a name="input_deploy_connectivity_resources"></a> [deploy\_connectivity\_resources](#input\_deploy\_connectivity\_resources)

Description: If enabled, deploy resources in connectivity subscription

Type: `bool`

Default: `true`

### <a name="input_deploy_identity_resources"></a> [deploy\_identity\_resources](#input\_deploy\_identity\_resources)

Description: If enabled, deploy resources in identity subscription

Type: `bool`

Default: `true`

### <a name="input_deploy_management_resources"></a> [deploy\_management\_resources](#input\_deploy\_management\_resources)

Description: If enabled, deploy resources in management subscription

Type: `bool`

Default: `true`

### <a name="input_log_retention_in_days"></a> [log\_retention\_in\_days](#input\_log\_retention\_in\_days)

Description: Retention in days for log analytics workspace

Type: `number`

Default: `50`

### <a name="input_management_resources_location"></a> [management\_resources\_location](#input\_management\_resources\_location)

Description: Location for management resources

Type: `string`

Default: `"westeurope"`

### <a name="input_management_resources_tags"></a> [management\_resources\_tags](#input\_management\_resources\_tags)

Description: Default tags applied to all management resources

Type: `map(string)`

Default:

```json
{
  "managed-by-terraform": "true"
}
```

### <a name="input_root_id"></a> [root\_id](#input\_root\_id)

Description: Root ID used for naming ALZ resources

Type: `string`

Default: `"ac24"`

### <a name="input_root_name"></a> [root\_name](#input\_root\_name)

Description: Root Name used for naming ALZ resources

Type: `string`

Default: `"Atea-Community-2024"`

### <a name="input_sandbox_subscription_ids"></a> [sandbox\_subscription\_ids](#input\_sandbox\_subscription\_ids)

Description: List of sandbox subscription ids

Type: `list(string)`

Default: `[]`

## Outputs

No outputs.

## Modules

The following Modules are called:

### <a name="module_azure_landing_zones"></a> [azure\_landing\_zones](#module\_azure\_landing\_zones)

Source: Azure/caf-enterprise-scale/azurerm

Version: 6.1.0
<!-- END_TF_DOCS -->