resource "azurerm_container_registry" "acr" {
  name                = "acr${var.name_suffix}"
  resource_group_name = var.mainrg
  location            = var.region
  sku                 = var.sku
  admin_enabled       = false
}
