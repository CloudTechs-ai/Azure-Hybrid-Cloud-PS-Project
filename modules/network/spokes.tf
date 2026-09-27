# App spoke: where compute workloads live.
resource "azurerm_virtual_network" "app_spoke" {
  name                = "vnet-app-${var.project}"
  resource_group_name = var.resource_group_name
  location            = var.location
  address_space       = var.app_spoke_address_space
  tags                = var.tags
}

resource "azurerm_subnet" "app" {
  name                 = "snet-app"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.app_spoke.name
  address_prefixes     = [cidrsubnet(var.app_spoke_address_space[0], 2, 0)]
}

resource "azurerm_network_security_group" "app" {
  name                = "nsg-app-${var.project}"
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags

  security_rule {
    name                       = "AllowVnetInbound"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "VirtualNetwork"
  }

  security_rule {
    name                       = "DenyAllInbound"
    priority                   = 4096
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "app" {
  subnet_id                 = azurerm_subnet.app.id
  network_security_group_id = azurerm_network_security_group.app.id
}

# Data spoke: where PaaS resources (Storage, Key Vault) live behind private endpoints.
resource "azurerm_virtual_network" "data_spoke" {
  name                = "vnet-data-${var.project}"
  resource_group_name = var.resource_group_name
  location            = var.location
  address_space       = var.data_spoke_address_space
  tags                = var.tags
}

resource "azurerm_subnet" "data" {
  name                 = "snet-data"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.data_spoke.name
  address_prefixes     = [cidrsubnet(var.data_spoke_address_space[0], 2, 0)]
}

# Dedicated subnet for private endpoints. Keeping these separate from
# general workload subnets is an Azure best practice and worth mentioning
# in an interview.
resource "azurerm_subnet" "private_endpoints" {
  name                 = "snet-pe"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.data_spoke.name
  address_prefixes     = [cidrsubnet(var.data_spoke_address_space[0], 2, 1)]

  private_endpoint_network_policies = "Disabled"
}

resource "azurerm_network_security_group" "data" {
  name                = "nsg-data-${var.project}"
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags

  security_rule {
    name                       = "AllowVnetInbound"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "VirtualNetwork"
  }

  security_rule {
    name                       = "DenyAllInbound"
    priority                   = 4096
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "data" {
  subnet_id                 = azurerm_subnet.data.id
  network_security_group_id = azurerm_network_security_group.data.id
}