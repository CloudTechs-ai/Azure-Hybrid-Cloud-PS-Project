variable "resource_group_name" {
  description = "Resource group for monitoring resources"
  type        = string
}

variable "location" {
  description = "Azure region for monitoring resources"
  type        = string
}

variable "project" {
  description = "Short project name used in resource names"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "tags" {
  description = "Common tags applied to monitoring resources"
  type        = map(string)
  default     = {}
}

variable "retention_in_days" {
  description = "Log Analytics retention period"
  type        = number
  default     = 30
}

variable "diagnostic_resource_ids" {
  description = "Azure resource IDs to send platform diagnostics to this workspace"
  type        = map(string)
  default     = {}
}

variable "enable_subscription_activity_log" {
  description = "Send subscription Activity Log events to this workspace"
  type        = bool
  default     = false
}