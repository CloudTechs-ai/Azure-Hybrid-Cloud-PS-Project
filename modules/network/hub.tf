# Virtual WAN: the top-level container. One vWAN can hold multiple hubs
# across regions; we only need one hub for this project.
resource "azurerm_virtual_wan" "main" {
  name                = "vwan-${var.project}"
  resource_group_name = var.resource_group_name
  location            = var.location
  type                = "Standard" # Standard required for VPN gateway + routing intent
  tags                = var.tags
}

# The hub: a managed VNet that Azure creates and controls. Spokes connect to
# this, not to each other directly - the hub does the routing.
resource "azurerm_virtual_hub" "main" {
  name                = "vhub-${var.project}"
  resource_group_name = var.resource_group_name
  location            = var.location
  virtual_wan_id      = azurerm_virtual_wan.main.id
  address_prefix      = var.hub_address_prefix
  tags                = var.tags
}