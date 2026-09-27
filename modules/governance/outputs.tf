output "policy_definition_id" {
  description = "ID of the environment tag policy definition"
  value       = azurerm_policy_definition.environment_tag.id
}

output "policy_assignment_id" {
  description = "ID of the environment tag policy assignment"
  value       = azurerm_resource_group_policy_assignment.environment_tag.id
}