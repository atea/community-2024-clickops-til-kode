terraform {
  backend "azurerm" {}
  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 3.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
      configuration_aliases = [
        azurerm.connectivity,
        azurerm.identity
      ]
    }
  }
  required_version = "~> 1.0"
}

provider "azuread" {}

provider "azurerm" {
  subscription_id = var.management_subscription_id
  features {

  }
}

provider "azurerm" {
  alias           = "connectivity"
  subscription_id = var.connectivity_subscription_id
  features {

  }
}

provider "azurerm" {
  alias           = "identity"
  subscription_id = var.identity_subscription_id
  features {

  }
}