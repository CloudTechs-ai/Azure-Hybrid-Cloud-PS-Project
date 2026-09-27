# Remote state backend. The state key is unique to this environment.

terraform {
  backend "azurerm" {
    resource_group_name  = "rg-tfstate-test01ahcps"
    storage_account_name = "sttfstatetest01ahcps"
    container_name       = "tfstate"
    key                  = "test.terraform.tfstate"
    use_azuread_auth     = true
    use_oidc             = true
  }
}