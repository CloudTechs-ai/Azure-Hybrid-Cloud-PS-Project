resource "azurerm_resource_group" "main" {
  name     = "rg-${var.project}-${var.environment}"
  location = var.location
  tags     = var.tags
}

module "network" {
  source              = "../modules/network"
  resource_group_name = azurerm_resource_group.main.name
  location            = var.location
  project             = var.project
  tags                = var.tags
  enable_p2s_vpn      = false
}