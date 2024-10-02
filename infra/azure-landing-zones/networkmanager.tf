/* module "naming" {
  source  = "Azure/naming/azurerm"
  version = "~> 0.4"
  suffix  = [var.root_id]
}

locals {
  nmg_tags = {
    owner       = "community-demo@ateaacfs.onmicrosoft.com"
    description = "Azure Network Manager for Atea Community 2024 demo"
  }
  network_manager_network_groups = [
    "arc",
    "corp",
    "online",
    "secure"
  ]
}

resource "azurerm_resource_group" "network_manager" {
  provider = azurerm.connectivity
  name     = "${module.naming.resource_group.name}-network-manager"
  location = var.default_location

  tags = local.nmg_tags
}

resource "azurerm_network_manager" "this" {
  provider            = azurerm.connectivity
  name                = "vnm-${var.root_id}"
  location            = azurerm_resource_group.network_manager.location
  resource_group_name = azurerm_resource_group.network_manager.name
  scope {
    management_group_ids = [
      module.azure_landing_zones.azurerm_management_group.level_2["/providers/Microsoft.Management/managementGroups/ac24-platform"].id,
      module.azure_landing_zones.azurerm_management_group.level_2["/providers/Microsoft.Management/managementGroups/ac24-landing-zones"].id
    ]
  }
  scope_accesses = ["Connectivity", "SecurityAdmin"]
  description    = local.nmg_tags.description

  tags = local.nmg_tags
}

resource "azurerm_network_manager_network_group" "spokes" {
  provider           = azurerm.connectivity
  for_each           = toset(local.network_manager_network_groups)
  name               = each.key
  network_manager_id = azurerm_network_manager.this.id
}

resource "azurerm_network_manager_connectivity_configuration" "hub_spoke" {
  provider              = azurerm.connectivity
  name                  = "${var.root_id}-hub-spoke"
  network_manager_id    = azurerm_network_manager.this.id
  connectivity_topology = "HubAndSpoke"


  dynamic "applies_to_group" {
    for_each = azurerm_network_manager_network_group.spokes
    content {
      group_connectivity = "DirectlyConnected"
      network_group_id   = applies_to_group.value.id
      use_hub_gateway    = true
    }
  }

  hub {
    resource_id   = module.azure_landing_zones.azurerm_virtual_network.connectivity["/subscriptions/4f047f6d-f7fd-4747-832c-a5afe38df8fb/resourceGroups/ac24-connectivity-westeurope/providers/Microsoft.Network/virtualNetworks/ac24-hub-westeurope"].id
    resource_type = "Microsoft.Network/virtualNetworks"
  }
}

resource "azurerm_network_manager_deployment" "connectivity" {
  network_manager_id = azurerm_network_manager.this.id
  location           = var.default_location
  scope_access       = "Connectivity"
  configuration_ids = [
    azurerm_network_manager_connectivity_configuration.hub_spoke.id
  ]
} */