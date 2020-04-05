resource "azurerm_sql_server" "sql-server" {
  name                         = "sql-server-${var.name_suffix}"
  resource_group_name          = var.mainrg
  location                     = var.region
  version                      = "12.0"
  administrator_login          = "sqladmin"
  administrator_login_password = var.sql_server_pass
}

resource "azurerm_sql_database" "sql-db" {
  name                = "sql-db-${var.name_suffix}"
  resource_group_name = var.mainrg
  location            = var.region
  server_name         = azurerm_sql_server.sql-server.name
  edition             = var.edition
}