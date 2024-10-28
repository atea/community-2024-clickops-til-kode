variable "address_space" {
  type        = string
  default     = "10.42.0.0/16"
  description = "Address space for the virtual networks"
}

variable "default_location" {
  type        = string
  default     = "norwayeast"
  description = "Azure region for resources"
}

variable "enable_telemetry" {
  type        = bool
  default     = false
  description = <<DESCRIPTION
This variable controls whether or not telemetry is enabled for the module.
For more information see <https://aka.ms/avm/telemetryinfo>.
If it is set to false, then no telemetry will be collected.
DESCRIPTION
}

variable "environments" {
  type = map(object({
    address_space = string
  }))
  default = {
    dev = {
      address_space = "10.42.0.0/16"
    }
    prod = {
      address_space = "10.43.0.0/16"
    }
  }
  description = "Set of environments to create"
}

variable "subscription_id" {
  type        = string
  description = "specify azure subscription id for resources"
}