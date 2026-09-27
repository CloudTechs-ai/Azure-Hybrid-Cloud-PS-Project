variable "suffix" {
  description = "Short unique suffix (e.g. your initials) used in resource naming across the project. Must match what you passed to bootstrap-backend.ps1."
  type        = string
}

variable "location" {
  description = "Azure region to deploy into."
  type        = string
  default     = "eastus"
}

variable "tags" {
  description = "Common tags applied to all resources."
  type        = map(string)
  default = {
    project = "azure-hybrid-cloud"
    env     = "dev"
  }
}

variable "aad_tenant_id" {
  description = "Entra ID (Azure AD) tenant ID used to authenticate point-to-site VPN clients. Find it with: az account show --query tenantId -o tsv"
  type        = string
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
  description = "Subnet prefix inside the app spoke."
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
  description = "Address pool handed out to point-to-site VPN clients."
  type        = list(string)
  default     = ["172.16.0.0/24"]
}
