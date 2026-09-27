# Connects each spoke VNet to the Virtual WAN hub. This is what makes the
# hub the routing point between spokes, rather than peering spokes directly
# to each other.

resource "azurerm_virtual_hub_connection" "app_spoke" {
  name                      = "conn-app-spoke"
  virtual_hub_id            = azurerm_virtual_hub.main.id
  remote_virtual_network_id = azurerm_virtual_network.app_spoke.id
}

resource "azurerm_virtual_hub_connection" "data_spoke" {
  name                      = "conn-data-spoke"
  virtual_hub_id            = azurerm_virtual_hub.main.id
  remote_virtual_network_id = azurerm_virtual_network.data_spoke.id
}