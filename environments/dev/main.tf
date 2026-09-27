terraform {
  required_version = ">= 1.5.0"
}

resource "azurerm_resource_group" "main" {
  name     = "rg-hybrid-${var.suffix}"
  location = var.location
  tags     = var.tags
}
module "network" {
  source              = "../../modules/network"
  resource_group_name = azurerm_resource_group.main.name
  location            = var.location
  suffix              = var.suffix
  tags                = var.tags

  aad_tenant_id = var.aad_tenant_id

  hub_address_prefix          = var.hub_address_prefix
  app_spoke_address_space     = var.app_spoke_address_space
  app_spoke_subnet_prefix     = var.app_spoke_subnet_prefix
  data_spoke_address_space    = var.data_spoke_address_space
  data_spoke_subnet_prefix    = var.data_spoke_subnet_prefix
  data_spoke_pe_subnet_prefix = var.data_spoke_pe_subnet_prefix
  vpn_client_address_pool     = var.vpn_client_address_pool
}
