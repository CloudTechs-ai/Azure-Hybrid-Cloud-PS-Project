# Remote state backend.
#
# These values come from scripts/Bootstrap-Backend.ps1,
# then run `terraform init`. Until this is filled in, Terraform will use local
# state, which is fine for a first `terraform init` test but not for the real build.

terraform {
  backend "azurerm" {
    resource_group_name  = "rg-tfstate-dev01ahcps"
    storage_account_name = "sttfstatedev01ahcps"
    container_name       = "tfstate"
    key                  = "dev.terraform.tfstate"
    use_azuread_auth     = true
    use_oidc             = true
  }
}