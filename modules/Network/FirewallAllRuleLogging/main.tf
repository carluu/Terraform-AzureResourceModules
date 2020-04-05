data "azurerm_resource_group" "rg-main" {
name = var.mainrg
}

resource "azurerm_subnet" "firewallsubnet" {
  name                 = "AzureFirewallSubnet"
  resource_group_name  = data.azurerm_resource_group.rg-main.name
  virtual_network_name = var.core_network_name
  address_prefix       = var.core_network_firewall_subnet_cidr
}

resource "azurerm_public_ip" "firewallpubip" {
  name                = "testpip-${var.name_suffix}"
  location            = data.azurerm_resource_group.rg-main.location
  resource_group_name = data.azurerm_resource_group.rg-main.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_firewall" "azurefirewall" {
  name                = "firewall-${var.name_suffix}"
  location            = data.azurerm_resource_group.rg-main.location
  resource_group_name = data.azurerm_resource_group.rg-main.name

  ip_configuration {
    name                 = "ipconfiguration"
    subnet_id            = azurerm_subnet.firewallsubnet.id
    public_ip_address_id = azurerm_public_ip.firewallpubip.id
  }
}

resource "azurerm_firewall_network_rule_collection" "catchallrule" {
  name                = "catchallrule"
  azure_firewall_name = azurerm_firewall.azurefirewall.name
  resource_group_name = data.azurerm_resource_group.rg-main.name
  priority            = 100
  action              = "Allow"

  rule {
    name = "testrule"

    source_addresses = [
      "*",
    ]

    destination_ports = [
      "*",
    ]

    destination_addresses = [
      "*",
    ]

    protocols = [
      "Any",
    ]
  }
}

resource "azurerm_monitor_diagnostic_setting" "firewalldiag" {
  name               = "firewalldiag"
  target_resource_id = azurerm_firewall.azurefirewall.id
  log_analytics_workspace_id = var.defaultworkspaceid

  log {
    category = "AzureFirewallApplicationRule"
    enabled  = true

    retention_policy {
      enabled = true
      days = 0
    }
  }

  log {
    category = "AzureFirewallNetworkRule"
    enabled  = true

    retention_policy {
      enabled = true
      days = 0
    }
  }

  metric {
    category = "AllMetrics"

    retention_policy {
      enabled = true
      days = 0
    }
  }
}

resource "azurerm_route_table" "routetofirewall" {
  name                          = "routetofirewall"
  location                      = data.azurerm_resource_group.rg-main.location
  resource_group_name           = data.azurerm_resource_group.rg-main.name
  disable_bgp_route_propagation = false

  route {
    name           = "routetofirewall"
    address_prefix = "0.0.0.0/0"
    next_hop_type  = "VirtualAppliance"
    next_hop_in_ip_address = azurerm_firewall.azurefirewall.ip_configuration[0].private_ip_address
  }
}

resource "azurerm_subnet_route_table_association" "default_routetofirewall" {
  subnet_id      = var.default_subnet_id
  route_table_id = azurerm_route_table.routetofirewall.id
}