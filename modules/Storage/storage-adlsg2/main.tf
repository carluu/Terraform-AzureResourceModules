resource "azurerm_storage_account" "storage-account" {
  name                = "storageadlsg2${var.name_suffix}"
  resource_group_name = var.mainrg
  location            = var.region
  account_tier            = var.tier
  account_replication_type = var.replication
  account_kind = var.kind
  is_hns_enabled = true
}