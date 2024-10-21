terraform {
  backend "azurerm" {}
  required_providers {
    azapi = {
      source  = "Azure/azapi"
      version = "~> 1.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.0"
    }
    azurerm = {
      source                = "hashicorp/azurerm"
      version               = "~> 4.6"
      configuration_aliases = [azurerm.connectivity]
    }
  }
  required_version = "~> 1.0"
}

provider "azapi" {
  use_cli = true
  use_msi = false
}

provider "azuread" {}

provider "azurerm" {
  features {}
}

provider "azurerm" {
  alias           = "connectivity"
  subscription_id = var.connectivity_subscription_id
  features {}
}