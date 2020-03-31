resource "azurerm_resource_group" "rg-firewall" {
  name     = "rg-firewall-${var.name_suffix}"
  location = var.region
}

resource "az" "name" {

}
