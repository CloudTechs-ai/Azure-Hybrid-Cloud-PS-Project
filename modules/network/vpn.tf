# Point-to-site VPN gateway on the hub, so you can connect from your own
# laptop (Azure VPN Client) to simulate "on-premises" without real hardware.
#
# This models what the recruiter is calling "on-prem to Azure connectivity"
# for demo purposes. In a real engagement this would typically be a
# site-to-site connection via a physical VPN device or ExpressRoute, and
# that distinction is worth stating explicitly in an interview.

resource "azurerm_vpn_gateway" "main" {
  count               = var.enable_p2s_vpn ? 1 : 0
  name                = "vpngw-${var.project}"
  resource_group_name = var.resource_group_name
  location            = var.location
  virtual_hub_id      = azurerm_virtual_hub.main.id
  tags                = var.tags
}

resource "azurerm_point_to_site_vpn_gateway" "main" {
  count               = var.enable_p2s_vpn ? 1 : 0
  name                = "p2svpngw-${var.project}"
  location            = var.location
  resource_group_name = var.resource_group_name
  virtual_hub_id      = azurerm_virtual_hub.main.id

  vpn_server_configuration_id = azurerm_vpn_server_configuration.main[0].id
  scale_unit                  = 1 # smallest/cheapest size, fine for a demo

  connection_configuration {
    name = "p2s-connection"
    vpn_client_address_pool {
      address_prefixes = var.p2s_address_pool
    }
  }

  tags = var.tags
}

# Server configuration for the P2S gateway: defines how clients authenticate.
# Using Azure AD (Entra ID) authentication ties this directly back into the
# identity module, which is one of the recruiter's questions.
resource "azurerm_vpn_server_configuration" "main" {
  count                    = var.enable_p2s_vpn ? 1 : 0
  name                     = "vpnserverconfig-${var.project}"
  resource_group_name      = var.resource_group_name
  location                 = var.location
  vpn_authentication_types = ["AAD"]

  azure_active_directory_authentication {
    audience = "c632b3df-fb67-4d84-bdcf-b95ad541b5c8" # Azure VPN Client's well-known app ID
    issuer   = "https://sts.windows.net/${data.azurerm_client_config.current.tenant_id}/"
    tenant   = "https://login.microsoftonline.com/${data.azurerm_client_config.current.tenant_id}/"
  }

  tags = var.tags
}

data "azurerm_client_config" "current" {}