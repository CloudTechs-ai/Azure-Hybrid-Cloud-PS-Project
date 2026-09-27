output "resource_group_name" {
  description = "Name of the resource group holding this environment"
  value       = azurerm_resource_group.main.name
}

output "location" {
  description = "Azure region used for this environment"
  value       = var.location
}