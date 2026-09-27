variable "project" {
  description = "Short project name used as a naming prefix"
  type        = string
  default     = "hybridclouddemo"
}

variable "environment" {
  description = "Demo environment name"
  type        = string
  default     = "demo"
}

variable "location" {
  description = "Azure region for the demo plan"
  type        = string
  default     = "eastus"
}

variable "tags" {
  description = "Common tags applied to demo resources"
  type        = map(string)
  default = {
    project     = "azure-hybrid-cloud"
    environment = "demo"
    managed_by  = "terraform"
  }
}