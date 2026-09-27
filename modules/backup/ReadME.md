# Backup module

Creates a geo-redundant Recovery Services vault with soft delete enabled and a daily
VM backup policy. The policy retains daily, weekly, monthly, and yearly recovery points.

The VM association is intentionally not included yet because the project does not define
an Azure VM. Once a VM exists, add an `azurerm_backup_protected_vm` resource using the
vault and policy outputs.