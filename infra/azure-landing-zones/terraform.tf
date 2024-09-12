terraform {
    required_providers {
      azurerm = {
        source = "hashicorp/azurerm"
        version = "~> 3.0"
        configuration_aliases = [
          azurerm.connectivity
        ]
      }
    }
    required_version = "~> 1.0"
}

provider "azurerm" {
  subscription_id = var.management_subscription_id
  features {

  }
}

provider "azurerm" {
  alias = "connectivity"
  subscription_id = var.connectivity_subscription_id
  features {
    
  }
}