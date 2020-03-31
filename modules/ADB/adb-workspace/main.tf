resource "azurerm_databricks_workspace" "adb-workspace" {
  name                = "adb-workspace-${var.name_suffix}"
  resource_group_name = var.mainrg
  location            = var.region
  sku                 = var.sku
}
