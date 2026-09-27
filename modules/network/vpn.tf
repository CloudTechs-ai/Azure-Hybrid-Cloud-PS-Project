# -----------------------------------------------------------------------------
# vpn.tf
# Point-to-site VPN so this environment can be reached from a laptop with the
# Azure VPN Client, authenticated via Entra ID (no on-prem hardware, no
# pre-shared certificates to manage). This stands in for a real site-to-site
# link in this demo; see modules/network/README.md for the tradeoff writeup.
# -----------------------------------------------------------------------------

locals {
  aad_issuer = var.aad_issuer != null ? var.aad_issuer : "https://sts.windows.net/${var.aad_tenant_id}/"
}

resource "azurerm_vpn_server_configuration" "this" {
  name                     = "vpnconfig-${var.suffix}"
  resource_group_name      = var.resource_group_name
  location                 = var.location
  vpn_authentication_types = ["AAD"]

  azure_active_directory_authentication {
    audience = var.aad_audience
    issuer   = local.aad_issuer
    tenant   = "https://login.microsoftonline.com/${var.aad_tenant_id}/"
  }

  tags = var.tags
}

resource "azurerm_point_to_site_vpn_gateway" "this" {
  name                        = "p2svpn-${var.suffix}"
  resource_group_name        = var.resource_group_name
  location                   = var.location
  virtual_hub_id              = azurerm_virtual_hub.this.id
  vpn_server_configuration_id = azurerm_vpn_server_configuration.this.id
  scale_unit                  = 1

  connection_configuration {
    name = "p2s-conn-${var.suffix}"

    vpn_client_address_pool {
      address_prefixes = var.vpn_client_address_pool
    }
  }

  tags = var.tags
}
