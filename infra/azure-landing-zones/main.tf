data "azurerm_client_config" "current" {}

module "azure_landing_zones" {
  source  = "Azure/caf-enterprise-scale/azurerm"
  version = "6.1.0"

  default_location  = "westeurope"
  disable_telemetry = true

  providers = {
    azurerm              = azurerm
    azurerm.connectivity = azurerm.connectivity
    azurerm.management   = azurerm
  }

  root_parent_id = data.azurerm_client_config.current.tenant_id
  root_id        = var.root_id
  root_name      = var.root_name

  deploy_connectivity_resources    = var.deploy_connectivity_resources
  subscription_id_connectivity     = var.connectivity_subscription_id
  configure_connectivity_resources = local.configure_connectivity_resources

  deploy_identity_resources    = var.deploy_identity_resources
  subscription_id_identity     = var.identity_subscription_id
  configure_identity_resources = local.configure_identity_resources

  deploy_management_resources    = var.deploy_management_resources
  subscription_id_management     = var.management_subscription_id
  configure_management_resources = local.configure_management_resources

  deploy_corp_landing_zones   = true
  deploy_online_landing_zones = true

  archetype_config_overrides = {
    landing-zones = {
      archetype_id = "es_landing_zones"
      parameters = {
        Deny-Subnet-Without-Nsg = {
          effect = "Audit"
        }
        Deploy-VM-Backup = {
          effect = "AuditIfNotExists"
        }
      }
      access_control = {}
    }
  }

  subscription_id_overrides = {
    sandboxes = var.sandbox_subscription_ids
  }

  default_tags = {
    description = "Atea Community 2024 Demo"
    owner       = "trond.sjovang@atea.no"
  }
}

# Create a group, add owners and members, and assign the Contributor role to the group at the top management group level for Azure Landing Zones
data "azuread_client_config" "current" {}

data "azuread_user" "community_demo" {
  user_principal_name = "community-demo@ateaacfs.onmicrosoft.com"
}

resource "azuread_group" "community_demo_contributor" {
  display_name     = "ALZ-Community-Demo-Contributor"
  security_enabled = true

  owners = [
    data.azuread_client_config.current.object_id
  ]

  members = [
    data.azuread_user.community_demo.object_id
  ]
}

resource "azurerm_role_assignment" "azure_landing_zones_contributor" {
  scope                = module.azure_landing_zones.azurerm_management_group.level_1["/providers/Microsoft.Management/managementGroups/${var.root_id}"].id
  role_definition_name = "Contributor"
  principal_id         = azuread_group.community_demo_contributor.id
}