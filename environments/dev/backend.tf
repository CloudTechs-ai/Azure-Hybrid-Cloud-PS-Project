# Remote state backend.
#
# Fill in the four values below with the output of scripts/bootstrap-backend.sh,
# then run `terraform init`. Until this is filled in, Terraform will use local
# state, which is fine for a first `terraform init` test but not for the real build.

terraform {
  backend "azurerm" {
    resource_group_name  = "rg-tfstate-cjt01"
    storage_account_name = "sttfstatecjt01"
    container_name       = "tfstate"
    key                  = "dev.terraform.tfstate"
  }
}
