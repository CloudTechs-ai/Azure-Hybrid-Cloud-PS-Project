variable "resource_group_name" {
  description = "Name of the resource group all network resources are deployed into."
  type        = string
}

variable "location" {
  description = "Azure region for all network resources."
  type        = string
}

variable "suffix" {
  description = "Short unique suffix (e.g. initials) appended to resource names."
  type        = string
}

variable "tags" {
  description = "Common tags applied to all resources."
  type        = map(string)
  default     = {}
}

variable "hub_address_prefix" {
  description = "Address prefix for the Virtual Hub."
  type        = string
  default     = "10.0.0.0/23"
}

variable "app_spoke_address_space" {
  description = "Address space for the app spoke VNet."
  type        = list(string)
  default     = ["10.1.0.0/16"]
}

variable "app_spoke_subnet_prefix" {
  description = "Subnet prefix inside the app spoke for workload resources."
  type        = string
  default     = "10.1.1.0/24"
}

variable "data_spoke_address_space" {
  description = "Address space for the data spoke VNet."
  type        = list(string)
  default     = ["10.2.0.0/16"]
}

variable "data_spoke_subnet_prefix" {
  description = "Subnet prefix inside the data spoke for workload resources."
  type        = string
  default     = "10.2.1.0/24"
}

variable "data_spoke_pe_subnet_prefix" {
  description = "Dedicated subnet prefix in the data spoke reserved for private endpoints."
  type        = string
  default     = "10.2.2.0/24"
}

variable "vpn_client_address_pool" {
  description = "Address pool handed out to point-to-site VPN clients. Must not overlap hub or spoke ranges."
  type        = list(string)
  default     = ["172.16.0.0/24"]
}

variable "aad_tenant_id" {
  description = "Entra ID (Azure AD) tenant ID used to authenticate point-to-site VPN clients."
  type        = string
}

variable "aad_audience" {
  description = "Entra ID application ID for Azure VPN authentication (Microsoft's well-known public client ID for Azure VPN)."
  type        = string
  default     = "41b23e61-6c1e-4545-b367-cd054e0ed4b4"
}

variable "aad_issuer" {
  description = "Entra ID issuer URL. Leave null to auto-derive from aad_tenant_id."
  type        = string
  default     = null
}
