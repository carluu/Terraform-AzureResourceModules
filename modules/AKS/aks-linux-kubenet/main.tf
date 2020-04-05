resource "azurerm_kubernetes_cluster" "aks" {

  # Meta variables
  name                = "aks-linux-kubenet-${var.name_suffix}"
  resource_group_name = var.mainrg
  location            = var.region
  dns_prefix          = var.name_suffix

  # Pool config
  default_node_pool {
    name       = "default"
    node_count = var.poolnodes
    vm_size    = var.vm_size
  }

  # Service principal settings
  service_principal {
    client_id     = var.sp_client_id
    client_secret = var.sp_client_secret
  }

  # Network settings
  network_profile {
    network_plugin = "kubenet"
  }
}
