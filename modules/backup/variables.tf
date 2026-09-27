variable "resource_group_name" {
  description = "Resource group for backup resources"
  type        = string
}

variable "location" {
  description = "Azure region for backup resources"
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
  description = "Common tags applied to backup resources"
  type        = map(string)
  default     = {}
}

variable "daily_retention_days" {
  description = "Number of daily recovery points to retain"
  type        = number
  default     = 30
}

variable "weekly_retention_weeks" {
  description = "Number of weekly recovery points to retain"
  type        = number
  default     = 12
}

variable "monthly_retention_months" {
  description = "Number of monthly recovery points to retain"
  type        = number
  default     = 12
}

variable "yearly_retention_years" {
  description = "Number of yearly recovery points to retain"
  type        = number
  default     = 7
}