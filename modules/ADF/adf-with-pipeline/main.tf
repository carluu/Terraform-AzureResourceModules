resource "azurerm_data_factory" "adf" {
  name                = "adf-with-pipeline-${var.name_suffix}"
  resource_group_name = var.mainrg
  location            = var.region
}

resource "azurerm_data_factory_pipeline" "adf-pipeline" {
  name                = "adf-pipeline-${var.name_suffix}"
  resource_group_name = var.mainrg
  data_factory_name   = azurerm_data_factory.adf.name
}
