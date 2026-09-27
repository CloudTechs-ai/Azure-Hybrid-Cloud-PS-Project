output "hub_id" {
  description = "ID of the Virtual WAN hub"
  value       = azurerm_virtual_hub.main.id
}

output "vpn_gateway_id" {
  description = "ID of the site-to-site VPN gateway when enabled"
  value       = try(azurerm_vpn_gateway.main[0].id, null)
}

output "p2s_vpn_gateway_id" {
  description = "ID of the point-to-site VPN gateway when enabled"
  value       = try(azurerm_point_to_site_vpn_gateway.main[0].id, null)
}

output "app_spoke_vnet_id" {
  value = azurerm_virtual_network.app_spoke.id
}

output "app_subnet_id" {
  value = azurerm_subnet.app.id
}

output "data_spoke_vnet_id" {
  value = azurerm_virtual_network.data_spoke.id
}

output "data_subnet_id" {
  value = azurerm_subnet.data.id
}

output "private_endpoint_subnet_id" {
  description = "Subnet dedicated to private endpoints in the data spoke, used by later modules"
  value       = azurerm_subnet.private_endpoints.id
}