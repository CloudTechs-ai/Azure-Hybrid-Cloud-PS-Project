resource "azurerm_log_analytics_workspace" "main" {
  name                = "law-${var.project}-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "PerGB2018"
  retention_in_days   = var.retention_in_days
  tags                = var.tags
}

data "azurerm_monitor_diagnostic_categories" "platform" {
  for_each    = var.diagnostic_resource_ids
  resource_id = each.value
}

resource "azurerm_monitor_diagnostic_setting" "platform" {
  for_each                   = var.diagnostic_resource_ids
  name                       = "diag-${var.project}-${var.environment}-${each.key}"
  target_resource_id         = each.value
  log_analytics_workspace_id = azurerm_log_analytics_workspace.main.id

  dynamic "enabled_log" {
    for_each = data.azurerm_monitor_diagnostic_categories.platform[each.key].log_category_types
    content {
      category = enabled_log.value
    }
  }

  dynamic "metric" {
    for_each = data.azurerm_monitor_diagnostic_categories.platform[each.key].metrics
    content {
      category = metric.value
    }
  }
}