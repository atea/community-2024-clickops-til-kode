# Core variables
variable "default_location" {
  type        = string
  default     = "westeurope"
  description = "Default location for all resources"
}

variable "root_id" {
  type        = string
  default     = "ac24"
  description = "Root ID used for naming ALZ resources"
}

variable "root_name" {
  type        = string
  default     = "Atea-Community-2024"
  description = "Root Name used for naming ALZ resources"
}

# Connectivity resources
variable "deploy_connectivity_resources" {
  type        = bool
  default     = true
  description = "If enabled, deploy resources in connectivity subscription"
}

variable "connectivity_subscription_id" {
  type        = string
  description = "Azure subscription ID for connectivity resources"
}

variable "connectivity_resources_location" {
  type        = string
  default     = "westeurope"
  description = "Location for connectivity resources"
}

variable "connectivity_resources_tags" {
  type = map(string)
  default = {
    managed-by-terraform = "true"
  }
  description = "Default tags applied to all connectivity resources"
}

# Identity resources
variable "deploy_identity_resources" {
  type        = bool
  default     = true
  description = "If enabled, deploy resources in identity subscription"
}

variable "identity_subscription_id" {
  type        = string
  description = "Azure subscription ID for identity resources"
}

# Management resources
variable "deploy_management_resources" {
  type        = bool
  default     = true
  description = "If enabled, deploy resources in management subscription"
}

variable "management_subscription_id" {
  type        = string
  description = "Azure subscription ID for management resources"
}

variable "log_retention_in_days" {
  type        = number
  default     = 50
  description = "Retention in days for log analytics workspace"
}

variable "security_alerts_email_address" {
  type        = string
  description = "Email address for security alerts"
}

variable "management_resources_location" {
  type        = string
  default     = "westeurope"
  description = "Location for management resources"
}

variable "management_resources_tags" {
  type = map(string)
  default = {
    managed-by-terraform = "true"
  }
  description = "Default tags applied to all management resources"
}

# Sandbox subscriptions
variable "sandbox_subscription_ids" {
  type        = list(string)
  default     = []
  description = "List of sandbox subscription ids"
}