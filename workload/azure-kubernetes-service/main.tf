terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  subscription_id = "e755f472-9b69-43be-8f61-d4d259713b80"
  features {

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
  source  = "Azure/naming/azurerm"
  version = ">= 0.3.0"
  suffix = [
    "atea",
    "community"
  ]
}

resource "azurerm_resource_group" "this" {
  location = "westeurope"
  name     = module.naming.resource_group.name_unique
}

resource "azurerm_user_assigned_identity" "this" {
  location            = azurerm_resource_group.this.location
  name                = "uami-${var.kubernetes_cluster_name}"
  resource_group_name = azurerm_resource_group.this.name
}

module "test" {
  source              = "Azure/avm-ptn-aks-production/azurerm"
  version             = "0.1.0"
  kubernetes_version  = "1.28"
  enable_telemetry    = var.enable_telemetry
  name                = module.naming.kubernetes_cluster.name_unique
  resource_group_name = azurerm_resource_group.this.name
  managed_identities = {
    user_assigned_resource_ids = [
      azurerm_user_assigned_identity.this.id
    ]
  }

  location = azurerm_resource_group.this.location
  node_pools = {
    workload = {
      name                 = "workload"
      vm_size              = "Standard_D2d_v5"
      orchestrator_version = "1.28"
      max_count            = 1
      min_count            = 1
      os_sku               = "Ubuntu"
      mode                 = "User"
    },
    ingress = {
      name                 = "ingress"
      vm_size              = "Standard_D2d_v5"
      orchestrator_version = "1.28"
      max_count            = 1
      min_count            = 1
      os_sku               = "Ubuntu"
      mode                 = "User"
    }
  }

  tags = local.tags
}