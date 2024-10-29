terraform {
  backend "azurerm" {}
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  subscription_id = var.subscription_id
  features {
    key_vault {
      purge_soft_delete_on_destroy    = true
      recover_soft_deleted_key_vaults = false
    }

    log_analytics_workspace {
      permanently_delete_on_destroy = true
    }
  }
}

locals {
  tags = {
    managed-by-terraform = true
    owner                = "trond.sjovang@atea.no"
    costcenter           = "app-avengers"
  }
}

module "naming" {
  source   = "Azure/naming/azurerm"
  version  = ">= 0.3.0"
  for_each = var.environments
  suffix = [
    "atea",
    "community",
    each.key
  ]
}

resource "azurerm_resource_group" "this" {
  for_each = var.environments
  location = var.default_location
  name     = module.naming[each.key].resource_group.name

  tags = local.tags
}

resource "azuread_group" "this" {
  for_each         = var.environments
  display_name     = "AKS-Admin-Atea-Community-${each.key}"
  mail_enabled     = false
  security_enabled = true
}

resource "azurerm_user_assigned_identity" "this" {
  for_each            = var.environments
  location            = azurerm_resource_group.this[each.key].location
  name                = module.naming[each.key].user_assigned_identity.name
  resource_group_name = azurerm_resource_group.this[each.key].name
}

module "loganalytics_workspace" {
  source              = "Azure/avm-res-operationalinsights-workspace/azurerm"
  version             = "0.4.1"
  for_each            = var.environments
  location            = azurerm_resource_group.this[each.key].location
  name                = module.naming[each.key].log_analytics_workspace.name
  resource_group_name = azurerm_resource_group.this[each.key].name
}

module "nat_gateway" {
  source              = "Azure/avm-res-network-natgateway/azurerm"
  version             = "0.2.0"
  for_each            = var.environments
  location            = azurerm_resource_group.this[each.key].location
  name                = module.naming[each.key].nat_gateway.name
  resource_group_name = azurerm_resource_group.this[each.key].name

  enable_telemetry = var.enable_telemetry

  public_ips = {
    pip-1 = {
      name = "ip-nat-gw-1"
    }
  }

  tags = merge(local.tags, {
    environment = each.key
  })
}

module "network_security_group" {
  source              = "Azure/avm-res-network-networksecuritygroup/azurerm"
  version             = "0.2.0"
  for_each            = var.environments
  location            = azurerm_resource_group.this[each.key].location
  name                = module.naming[each.key].network_security_group.name
  resource_group_name = azurerm_resource_group.this[each.key].name

  enable_telemetry = var.enable_telemetry

  security_rules = {
    allow-web = {
      access                     = "Allow"
      direction                  = "Inbound"
      name                       = "allow-web"
      priority                   = 100
      protocol                   = "*"
      resource_group_name        = azurerm_resource_group.this[each.key].name
      destination_address_prefix = "VirtualNetwork"
      destination_port_ranges = [
        "80",
        "443"
      ]
      source_address_prefix = "*"
      source_port_range     = "*"
    }
  }
}

module "network" {
  source              = "Azure/avm-res-network-virtualnetwork/azurerm"
  version             = "0.4.2"
  for_each            = var.environments
  enable_telemetry    = var.enable_telemetry
  resource_group_name = azurerm_resource_group.this[each.key].name
  location            = azurerm_resource_group.this[each.key].location
  name                = module.naming[each.key].virtual_network.name

  address_space = [each.value.address_space]

  diagnostic_settings = {
    diag = {
      workspace_resource_id = module.loganalytics_workspace[each.key].resource_id
    }
  }

  subnets = {
    nodes = {
      name = "sn-aks-nodes"
      address_prefixes = [
        cidrsubnet(each.value.address_space, 8, 0)
      ]
      nat_gateway = {
        id = module.nat_gateway[each.key].resource_id
      }
      network_security_group = {
        id = module.network_security_group[each.key].resource_id
      }
    }
    private_link = {
      name = "sn-private-link"
      address_prefixes = [
        cidrsubnet(each.value.address_space, 8, 1)
      ]
      nat_gateway = {
        id = module.nat_gateway[each.key].resource_id
      }
      network_security_group = {
        id = module.network_security_group[each.key].resource_id
      }
    }
  }
}

resource "azurerm_private_dns_zone" "this" {
  for_each            = var.environments
  name                = "privatelink.azurecr.io"
  resource_group_name = azurerm_resource_group.this[each.key].name
}

module "azure_kubernetes_cluster" {
  source              = "Azure/avm-ptn-aks-production/azurerm"
  version             = "0.2.0"
  for_each            = var.environments
  enable_telemetry    = var.enable_telemetry
  name                = module.naming[each.key].kubernetes_cluster.name
  resource_group_name = azurerm_resource_group.this[each.key].name
  location            = azurerm_resource_group.this[each.key].location

  kubernetes_version   = "1.28"
  orchestrator_version = "1.28"

  acr = {
    name                          = module.naming[each.key].container_registry.name
    subnet_resource_id            = module.network[each.key].subnets["private_link"].resource_id
    private_dns_zone_resource_ids = [azurerm_private_dns_zone.this[each.key].id]
  }

  network = {
    name                = module.network[each.key].name
    resource_group_name = azurerm_resource_group.this[each.key].name
    node_subnet_id      = module.network[each.key].subnets["nodes"].resource_id
    pod_cidr            = "192.168.0.0/16"
  }

  managed_identities = {
    user_assigned_resource_ids = [
      azurerm_user_assigned_identity.this[each.key].id
    ]
  }

  node_pools = {
    workload = {
      name                 = "workload"
      vm_size              = "Standard_D2s_v5"
      orchestrator_version = "1.28"
      min_count            = 1
      max_count            = 1
      os_sku               = "Ubuntu"
      mode                 = "User"
    }
  }

  rbac_aad_admin_group_object_ids = [
    azuread_group.this[each.key].object_id
  ]

  rbac_aad_azure_rbac_enabled = true

  tags = merge(local.tags, {
    environment = each.key
  })
}