# -----------------------------------------------------------------------------
# hub.tf
# Virtual WAN + Virtual Hub. This is the routing core that both spokes and the
# point-to-site VPN gateway attach to.
# -----------------------------------------------------------------------------

resource "azurerm_virtual_wan" "this" {
  name                = "vwan-${var.suffix}"
  resource_group_name = var.resource_group_name
  location             = var.location
  tags                = var.tags
}

resource "azurerm_virtual_hub" "this" {
  name                = "vhub-${var.suffix}"
  resource_group_name = var.resource_group_name
  location            = var.location
  virtual_wan_id      = azurerm_virtual_wan.this.id
  address_prefix      = var.hub_address_prefix
  tags                = var.tags
}
