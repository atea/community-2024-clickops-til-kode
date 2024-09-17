# Configure the management resources settings.
locals {
  configure_management_resources = {
    settings = {
      log_analytics = {
        enabled = true
        config = {
          retention_in_days                                 = var.log_retention_in_days
          enable_monitoring_for_vm                          = true
          enable_monitoring_for_vmss                        = true
          enable_solution_for_agent_health_assessment       = true
          enable_solution_for_anti_malware                  = true
          enable_solution_for_change_tracking               = true
          enable_solution_for_service_map                   = true
          enable_solution_for_sql_assessment                = true
          enable_solution_for_sql_vulnerability_assessment  = true
          enable_solution_for_sql_advanced_threat_detection = true
          enable_solution_for_updates                       = true
          enable_solution_for_vm_insights                   = true
          enable_solution_for_container_insights            = true
          enable_sentinel                                   = false
        }
      }
      security_center = {
        enabled = false
        config = {
          email_security_contact                                = var.security_alerts_email_address
          enable_defender_for_apis                              = false
          enable_defender_for_app_services                      = false
          enable_defender_for_arm                               = false
          enable_defender_for_containers                        = false
          enable_defender_for_cosmosdbs                         = false
          enable_defender_for_cspm                              = false
          enable_defender_for_dns                               = false
          enable_defender_for_key_vault                         = false
          enable_defender_for_oss_databases                     = false
          enable_defender_for_servers                           = false
          enable_defender_for_servers_vulnerability_assessments = false
          enable_defender_for_sql_servers                       = false
          enable_defender_for_sql_server_vms                    = false
          enable_defender_for_storage                           = false
        }
      }
    }

    location = var.management_resources_location
    tags     = var.management_resources_tags
    advanced = null
  }
}