resource "azurerm_eventhub_namespace" "eventhub-namespace" {
  name                = "eventhub-namespace-${var.name_suffix}"
  resource_group_name = var.mainrg
  location            = var.region
  sku                 = var.sku
  capacity            = var.capacity
}

resource "azurerm_eventhub" "eventhub" {
  name                = "eventhub-${var.name_suffix}"
  namespace_name      = azurerm_eventhub_namespace.eventhub-namespace.name
  resource_group_name = var.mainrg
  partition_count     = var.partitions
  message_retention   = var.retention
}