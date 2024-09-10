terraform {
    required_providers {
      azurerm = {
        source = "hashicorp/azurerm"
        version = "~> 4.0"
      }
    }
    required_version = "~> 1.0"
}

provider "azurerm" {
  resource_provider_registrations = "core"
  subscription_id = var.management_subscription_id
  features {}
}