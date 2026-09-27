resource "azurerm_recovery_services_vault" "main" {
  name                = "rsv-${var.project}-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "Standard"
  storage_mode_type   = "GeoRedundant"
  soft_delete_enabled = true
  tags                = var.tags
}

resource "azurerm_backup_policy_vm" "daily" {
  name                = "bkp-${var.project}-${var.environment}-daily"
  resource_group_name = var.resource_group_name
  recovery_vault_name = azurerm_recovery_services_vault.main.name
  timezone            = "UTC"
  policy_type         = "V2"

  backup {
    frequency = "Daily"
    time      = "23:00"
  }

  retention_daily {
    count = var.daily_retention_days
  }

  retention_weekly {
    count    = var.weekly_retention_weeks
    weekdays = ["Sunday"]
  }

  retention_monthly {
    count    = var.monthly_retention_months
    weekdays = ["Sunday"]
    weeks    = ["Last"]
  }

  retention_yearly {
    count    = var.yearly_retention_years
    months   = ["January"]
    weekdays = ["Sunday"]
    weeks    = ["Last"]
  }
}