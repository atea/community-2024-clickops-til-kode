data "azurerm_virtual_network" "hub" {
  provider            = azurerm.connectivity
  name                = "ac24-hub-westeurope"
  resource_group_name = "ac24-connectivity-westeurope"
}

locals {
  landing_zone_data_dir = "${path.module}/landing-zones"
  landing_zone_files    = fileset(local.landing_zone_data_dir, "*.yaml")
  landing_zone_data_map = {
    for f in local.landing_zone_files :
    f => yamldecode(file("${local.landing_zone_data_dir}/${f}"))
  }
}

resource "azuread_group" "owner" {
  for_each         = local.landing_zone_data_map
  display_name     = "LZ-${each.value.name}-Owner"
  security_enabled = true
}

module "lz_vending" {
  source            = "Azure/lz-vending/azurerm"
  version           = "4.1.5"
  disable_telemetry = true

  for_each = local.landing_zone_data_map

  location = "westeurope"

  subscription_id                                   = each.value.subscription_id
  subscription_display_name                         = each.value.name
  subscription_management_group_association_enabled = true
  subscription_management_group_id                  = "ac24-${each.value.subscription_type}"

  role_assignment_enabled = true
  role_assignments = {
    owner_user_sub = {
      principal_id   = azuread_group.owner["${each.value.name}.yaml"].object_id
      definition     = "Owner"
      relative_scope = ""
    }
  }

  budget_enabled = true
  budgets = {
    budget1 = {
      amount            = try(each.value.budget_amount, 1000)
      time_grain        = "Monthly"
      time_period_start = formatdate("YYYY-MM-'01T00:00:00'Z", timestamp())
      time_period_end   = "2027-12-31T23:59:59Z"
      notifications = {
        eightypercent = {
          enabled        = true
          operator       = "GreaterThan"
          threshold      = 80
          threshold_type = "Actual"
          contact_emails = coalesce(try(each.value.budget_notification_emails, null), ["trond.sjovang@atea.no"])
        }
        budgetexceeded = {
          enabled        = true
          operator       = "GreaterThan"
          threshold      = 100
          threshold_type = "Forecasted"
          contact_roles  = ["Owner"]
        }
      }
    }
  }

  virtual_network_enabled = true
  virtual_networks = {
    vnet1 = {
      name                        = "vnet-${each.value.name}"
      address_space               = each.value.virtual_networks.vnet1.address_space
      resource_group_name         = "rg-${each.value.name}-networking"
      hub_peering_enabled         = each.value.virtual_networks.vnet1.hub_peering_enabled
      hub_network_resource_id     = data.azurerm_virtual_network.hub.id
      resource_group_lock_enabled = false
      resource_group_tags = {
        costcenter = "platform"
        owner      = "community-demo@ateaacfs.onmicrosoft.com"
      }
    }
  }

  umi_enabled                     = true
  umi_name                        = "id-${each.value.name}"
  umi_resource_group_name         = "rg-${each.value.name}-identity"
  umi_resource_group_lock_enabled = false
  umi_resource_group_tags = {
    costcenter = "platform"
    owner      = "community-demo@ateaacfs.onmicrosoft.com"
  }
}