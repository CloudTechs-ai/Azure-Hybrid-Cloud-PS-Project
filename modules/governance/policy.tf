resource "azurerm_policy_definition" "environment_tag" {
  name         = "audit-environment-tag-${var.environment}"
  policy_type  = "Custom"
  mode         = "Indexed"
  display_name = "Audit missing environment tag (${var.environment})"
  description  = "Audits resources in the environment that do not have an environment tag."

  policy_rule = jsonencode({
    if = {
      field  = "tags[environment]"
      exists = "false"
    }
    then = {
      effect = "[parameters('effect')]"
    }
  })

  parameters = jsonencode({
    effect = {
      type = "String"
      metadata = {
        displayName = "Policy effect"
        description = "Audit resources or disable the assignment."
      }
      allowedValues = ["Audit", "Disabled"]
      defaultValue  = "Audit"
    }
  })
}

resource "azurerm_resource_group_policy_assignment" "environment_tag" {
  name                 = "audit-environment-tag-${var.environment}"
  resource_group_id    = var.resource_group_id
  policy_definition_id = azurerm_policy_definition.environment_tag.id
  display_name         = "Audit environment tag (${var.environment})"
  description          = "Audit-only governance assignment for the environment resource group."
  enforce              = true
  parameters           = jsonencode({ effect = { value = var.policy_effect } })
}