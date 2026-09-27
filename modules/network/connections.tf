# -----------------------------------------------------------------------------
# connections.tf
# Attaches each spoke VNet to the Virtual Hub so traffic routes through the
# hub (and, from there, out over the point-to-site VPN to your laptop).
# -----------------------------------------------------------------------------

resource "azurerm_virtual_hub_connection" "app" {
  name                      = "hubconn-app-${var.suffix}"
  virtual_hub_id            = azurerm_virtual_hub.this.id
  remote_virtual_network_id = azurerm_virtual_network.app.id
}

resource "azurerm_virtual_hub_connection" "data" {
  name                      = "hubconn-data-${var.suffix}"
  virtual_hub_id            = azurerm_virtual_hub.this.id
  remote_virtual_network_id = azurerm_virtual_network.data.id
}
