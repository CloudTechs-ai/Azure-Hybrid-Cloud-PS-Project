output "client_id" {
  description = "Client ID of the environment workload identity"
  value       = azurerm_user_assigned_identity.workload.client_id
}

output "principal_id" {
  description = "Principal ID of the environment workload identity"
  value       = azurerm_user_assigned_identity.workload.principal_id
}

output "resource_id" {
  description = "Resource ID of the environment workload identity"
  value       = azurerm_user_assigned_identity.workload.id
}