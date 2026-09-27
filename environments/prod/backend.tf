# Remote state backend. The state key is unique to this environment.

terraform {
  backend "azurerm" {
    resource_group_name  = "rg-tfstate-prod03ahcps"
    storage_account_name = "sttfstateprod03ahcps"
    container_name       = "tfstate"
    key                  = "prod.terraform.tfstate"
    use_azuread_auth     = true
    use_oidc             = true
  }
}