output "vault_id" {
  description = "Recovery Services vault resource ID"
  value       = azurerm_recovery_services_vault.main.id
}

output "vault_name" {
  description = "Recovery Services vault name"
  value       = azurerm_recovery_services_vault.main.name
}

output "policy_id" {
  description = "VM backup policy resource ID"
  value       = azurerm_backup_policy_vm.daily.id
}

output "policy_name" {
  description = "VM backup policy name"
  value       = azurerm_backup_policy_vm.daily.name
}