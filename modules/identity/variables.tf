variable "resource_group_name" {
  description = "Resource group for the managed identity"
  type        = string
}

variable "location" {
  description = "Azure region for the managed identity"
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
  description = "Common tags applied to the managed identity"
  type        = map(string)
  default     = {}
}