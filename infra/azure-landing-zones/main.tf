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
}