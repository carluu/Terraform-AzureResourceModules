resource "azurerm_subnet" "firewallsubnet" {
  name                 = "AzureFirewallSubnet"
  resource_group_name  = var.mainrg
  virtual_network_name = var.core_network_name
  address_prefix       = var.core_network_firewall_subnet_cidr
}

resource "azurerm_public_ip" "firewallpubip" {
  name                = "testpip"
  location            = var.region
  resource_group_name = var.mainrg
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_firewall" "azurefirewall" {
  name                = "firewall-${var.name_suffix}"
  location            = var.region
  resource_group_name = var.mainrg

  ip_configuration {
    name                 = "ipconfiguration"
    subnet_id            = azurerm_subnet.firewallsubnet.id
    public_ip_address_id = azurerm_public_ip.firewallpubip.id
  }
}
