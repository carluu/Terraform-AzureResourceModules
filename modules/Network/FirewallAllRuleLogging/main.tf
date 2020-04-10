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
  name                       = "firewalldiag"
  target_resource_id         = azurerm_firewall.azurefirewall.id
  log_analytics_workspace_id = var.defaultworkspaceid

  log {
    category = "AzureFirewallApplicationRule"
    enabled  = true

    retention_policy {
      enabled = true
      days    = 0
    }
  }

  log {
    category = "AzureFirewallNetworkRule"
    enabled  = true

    retention_policy {
      enabled = true
      days    = 0
    }
  }

  metric {
    category = "AllMetrics"

    retention_policy {
      enabled = true
      days    = 0
    }
  }
}