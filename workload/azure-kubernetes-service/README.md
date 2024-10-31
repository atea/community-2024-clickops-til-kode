<!-- BEGIN_TF_DOCS -->
# Azure Kubernetes Service

Denne demoen bruker [avm-ptn-aks-production](https://registry.terraform.io/modules/Azure/avm-ptn-aks-production/azurerm/latest), samt støtte-moduler for nettverk og logging, fra [Azure Verified Modules](https://azure.github.io/Azure-Verified-Modules/) til å sette opp Kubernetes-clustre for både test og produksjon

## Kjente bugs og løsninger

1. `terraform apply` feiler i et tomt miljø. Dette skjer fordi `avm-ptn-aks-production` prøver å lese inn ressursgruppen som et data-objekt. Kan løses ved å kjøre `terraform apply -target azurerm_resource_group.this` manuelt første gang

<!-- markdownlint-disable MD033 -->
## Requirements

The following requirements are needed by this module:

- <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) (~> 3.0)

## Resources

The following resources are used by this module:

- [azuread_group.this](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/group) (resource)
- [azurerm_private_dns_zone.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone) (resource)
- [azurerm_resource_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) (resource)
- [azurerm_user_assigned_identity.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/user_assigned_identity) (resource)

<!-- markdownlint-disable MD013 -->
## Required Inputs

The following input variables are required:

### <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id)

Description: specify azure subscription id for resources

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_address_space"></a> [address\_space](#input\_address\_space)

Description: Address space for the virtual networks

Type: `string`

Default: `"10.42.0.0/16"`

### <a name="input_default_location"></a> [default\_location](#input\_default\_location)

Description: Azure region for resources

Type: `string`

Default: `"norwayeast"`

### <a name="input_enable_telemetry"></a> [enable\_telemetry](#input\_enable\_telemetry)

Description: This variable controls whether or not telemetry is enabled for the module.  
For more information see <https://aka.ms/avm/telemetryinfo>.  
If it is set to false, then no telemetry will be collected.

Type: `bool`

Default: `false`

### <a name="input_environments"></a> [environments](#input\_environments)

Description: Set of environments to create

Type:

```hcl
map(object({
    address_space = string
  }))
```

Default:

```json
{
  "dev": {
    "address_space": "10.42.0.0/16"
  },
  "prod": {
    "address_space": "10.43.0.0/16"
  }
}
```

## Outputs

No outputs.

## Modules

The following Modules are called:

### <a name="module_azure_kubernetes_cluster"></a> [azure\_kubernetes\_cluster](#module\_azure\_kubernetes\_cluster)

Source: Azure/avm-ptn-aks-production/azurerm

Version: 0.2.0

### <a name="module_loganalytics_workspace"></a> [loganalytics\_workspace](#module\_loganalytics\_workspace)

Source: Azure/avm-res-operationalinsights-workspace/azurerm

Version: 0.4.1

### <a name="module_naming"></a> [naming](#module\_naming)

Source: Azure/naming/azurerm

Version: >= 0.3.0

### <a name="module_nat_gateway"></a> [nat\_gateway](#module\_nat\_gateway)

Source: Azure/avm-res-network-natgateway/azurerm

Version: 0.2.0

### <a name="module_network"></a> [network](#module\_network)

Source: Azure/avm-res-network-virtualnetwork/azurerm

Version: 0.4.2

### <a name="module_network_security_group"></a> [network\_security\_group](#module\_network\_security\_group)

Source: Azure/avm-res-network-networksecuritygroup/azurerm

Version: 0.2.0
<!-- END_TF_DOCS -->