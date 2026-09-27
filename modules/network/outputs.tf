# -----------------------------------------------------------------------------
# outputs.tf
# Exposed for future modules (governance, monitoring) and for the root config.
# -----------------------------------------------------------------------------

output "virtual_wan_id" {
  description = "Resource ID of the Virtual WAN."
  value       = azurerm_virtual_wan.this.id
}

output "virtual_hub_id" {
  description = "Resource ID of the Virtual Hub."
  value       = azurerm_virtual_hub.this.id
}

output "p2s_vpn_gateway_id" {
  description = "Resource ID of the point-to-site VPN gateway."
  value       = azurerm_point_to_site_vpn_gateway.this.id
}

output "app_vnet_id" {
  description = "Resource ID of the app spoke VNet."
  value       = azurerm_virtual_network.app.id
}

output "app_subnet_id" {
  description = "Resource ID of the app spoke workload subnet."
  value       = azurerm_subnet.app.id
}

output "data_vnet_id" {
  description = "Resource ID of the data spoke VNet."
  value       = azurerm_virtual_network.data.id
}

output "data_subnet_id" {
  description = "Resource ID of the data spoke workload subnet."
  value       = azurerm_subnet.data.id
}

output "data_pe_subnet_id" {
  description = "Resource ID of the data spoke's dedicated private-endpoint subnet."
  value       = azurerm_subnet.data_pe.id
}
