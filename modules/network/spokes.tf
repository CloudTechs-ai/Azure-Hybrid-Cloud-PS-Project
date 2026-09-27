# -----------------------------------------------------------------------------
# spokes.tf
# App spoke: general workload VNet.
# Data spoke: workload subnet + a dedicated subnet reserved for private
# endpoints, kept separate from workload traffic per best practice.
# -----------------------------------------------------------------------------

# ---------------------------- App spoke -------------------------------------

resource "azurerm_virtual_network" "app" {
  name                = "vnet-app-${var.suffix}"
  resource_group_name = var.resource_group_name
  location            = var.location
  address_space       = var.app_spoke_address_space
  tags                = var.tags
}

resource "azurerm_subnet" "app" {
  name                 = "snet-app-${var.suffix}"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.app.name
  address_prefixes     = [var.app_spoke_subnet_prefix]
}

resource "azurerm_network_security_group" "app" {
  name                = "nsg-app-${var.suffix}"
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags
}

resource "azurerm_subnet_network_security_group_association" "app" {
  subnet_id                 = azurerm_subnet.app.id
  network_security_group_id = azurerm_network_security_group.app.id
}

# ---------------------------- Data spoke -------------------------------------

resource "azurerm_virtual_network" "data" {
  name                = "vnet-data-${var.suffix}"
  resource_group_name = var.resource_group_name
  location            = var.location
  address_space       = var.data_spoke_address_space
  tags                = var.tags
}

resource "azurerm_subnet" "data" {
  name                 = "snet-data-${var.suffix}"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.data.name
  address_prefixes     = [var.data_spoke_subnet_prefix]
}

resource "azurerm_subnet" "data_pe" {
  name                 = "snet-data-pe-${var.suffix}"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.data.name
  address_prefixes     = [var.data_spoke_pe_subnet_prefix]

  private_endpoint_network_policies = "Disabled"
}

resource "azurerm_network_security_group" "data" {
  name                = "nsg-data-${var.suffix}"
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags
}

resource "azurerm_subnet_network_security_group_association" "data" {
  subnet_id                 = azurerm_subnet.data.id
  network_security_group_id = azurerm_network_security_group.data.id
}

resource "azurerm_network_security_group" "data_pe" {
  name                = "nsg-data-pe-${var.suffix}"
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags
}

resource "azurerm_subnet_network_security_group_association" "data_pe" {
  subnet_id                 = azurerm_subnet.data_pe.id
  network_security_group_id = azurerm_network_security_group.data_pe.id
}
