variable "resource_group_id" {
  description = "Resource group scope for the policy assignment"
  type        = string
}

variable "environment" {
  description = "Environment name used in the policy definition name"
  type        = string
}

variable "policy_effect" {
  description = "Policy effect; Audit is the safe default"
  type        = string
  default     = "Audit"

  validation {
    condition     = contains(["Audit", "Disabled"], var.policy_effect)
    error_message = "policy_effect must be Audit or Disabled."
  }
}