<!-- BEGIN_TF_DOCS -->
# Azure subscription vending machine

Eksemplet i denne mappen benytter Terraform-modulen [azurerm-lz-vending](https://github.com/Azure/terraform-azurerm-lz-vending/wiki/Example-3-YAML-data-files) for å lage en enkel "brusautomat" for selvbetjening av nye Azure subscriptions

<!-- markdownlint-disable MD033 -->
## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (~> 1.0)

- <a name="requirement_azapi"></a> [azapi](#requirement\_azapi) (~> 1.0)

- <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) (~> 2.0)

- <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) (~> 3.0)

## Resources

The following resources are used by this module:

- [azurerm_virtual_network.hub](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/virtual_network) (data source)

<!-- markdownlint-disable MD013 -->
## Required Inputs

The following input variables are required:

### <a name="input_connectivity_subscription_id"></a> [connectivity\_subscription\_id](#input\_connectivity\_subscription\_id)

Description: Azure subscription ID for connectivity resources

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_landing_zones"></a> [landing\_zones](#input\_landing\_zones)

Description: Map of landing zones to deploy

Type: `map(any)`

Default: `{}`

## Outputs

No outputs.

## Modules

The following Modules are called:

### <a name="module_lz_vending"></a> [lz\_vending](#module\_lz\_vending)

Source: Azure/lz-vending/azurerm

Version: = 4.1.3
<!-- END_TF_DOCS -->