output "resource_group_name" {
  description = "Resource group that would contain the demo resources"
  value       = azurerm_resource_group.main.name
}

output "app_spoke_vnet_id" {
  description = "App spoke VNet that would be created by the demo plan"
  value       = module.network.app_spoke_vnet_id
}

output "data_spoke_vnet_id" {
  description = "Data spoke VNet that would be created by the demo plan"
  value       = module.network.data_spoke_vnet_id
}