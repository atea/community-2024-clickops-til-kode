variable "connectivity_subscription_id" {
  type        = string
  description = "Azure subscription ID for connectivity resources"
}

variable "landing_zones" {
  type        = map(any)
  default     = {}
  description = "Map of landing zones to deploy"
}