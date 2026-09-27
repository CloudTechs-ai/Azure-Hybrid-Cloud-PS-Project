resource "azurerm_resource_group" "main" {
  name     = "rg-${var.project}-${var.environment}"
  location = var.location
  tags     = var.tags
}

module "network" {
  source              = "../../modules/network"
  resource_group_name = azurerm_resource_group.main.name
  location            = var.location
  project             = var.project
  tags                = var.tags
  enable_p2s_vpn      = true
}

module "monitoring" {
  source                           = "../../modules/monitoring"
  resource_group_name              = azurerm_resource_group.main.name
  location                         = var.location
  project                          = var.project
  environment                      = var.environment
  tags                             = var.tags
  enable_subscription_activity_log = true
  diagnostic_resource_ids = {
    virtual_hub     = module.network.hub_id
    app_vnet        = module.network.app_spoke_vnet_id
    data_vnet       = module.network.data_spoke_vnet_id
    vpn_gateway     = module.network.vpn_gateway_id
    p2s_vpn_gateway = module.network.p2s_vpn_gateway_id
  }
}
module "governance" {
  source            = "../../modules/governance"
  resource_group_id = azurerm_resource_group.main.id
  environment       = var.environment
}

module "identity" {
  source              = "../../modules/identity"
  resource_group_name = azurerm_resource_group.main.name
  location            = var.location
  project             = var.project
  environment         = var.environment
  tags                = var.tags
}

module "backup" {
  source              = "../../modules/backup"
  resource_group_name = azurerm_resource_group.main.name
  location            = var.location
  project             = var.project
  environment         = var.environment
  tags                = var.tags
}
