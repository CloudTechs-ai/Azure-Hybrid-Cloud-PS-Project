variable "resource_group_name" {
  description = "Resource group to deploy networking resources into"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "tags" {
  description = "Common tags"
  type        = map(string)
  default     = {}
}

variable "project" {
  description = "Short project name used as a naming prefix"
  type        = string
  default     = "hybridcloud"
}

variable "hub_address_prefix" {
  description = "Address prefix for the Virtual WAN hub"
  type        = string
  default     = "10.0.0.0/23"
}

variable "app_spoke_address_space" {
  description = "Address space for the app spoke VNet"
  type        = list(string)
  default     = ["10.1.0.0/24"]
}

variable "data_spoke_address_space" {
  description = "Address space for the data spoke VNet"
  type        = list(string)
  default     = ["10.2.0.0/24"]
}

variable "enable_p2s_vpn" {
  description = "Whether to deploy a point-to-site VPN gateway on the hub for laptop-based testing"
  type        = bool
  default     = true
}

variable "p2s_address_pool" {
  description = "Address pool assigned to point-to-site VPN clients"
  type        = list(string)
  default     = ["172.16.0.0/24"]
}