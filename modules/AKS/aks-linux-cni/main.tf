# Calculate IPs
# Applies formula for required IPs and then calculates the mask that would provide enough IPs
# Then generates an IP space using that mask
locals {
  requiredIps           = (var.poolnodes + 1) + ((var.poolnodes + 1) * var.podspernode)
  subnetMask            = 32 - ceil(log(local.requiredIps, 2))
  cluster_address_space = "${var.k8s_cni_startIp}/${local.subnetMask}"
}

# Create the subnet
resource "azurerm_subnet" "cluster-subnet" {
  virtual_network_name = var.core_network_name
  name                 = "subnet-aks-linux-cni-cluster-${var.name_suffix}"
  resource_group_name  = var.mainrg
  address_prefix       = local.cluster_address_space
}

resource "azurerm_kubernetes_cluster" "aks" {

  # Meta variables
  name                = "aks-linux-cni-${var.name_suffix}"
  resource_group_name = var.mainrg
  location            = var.region
  dns_prefix          = var.name_suffix

  # Pool config
  default_node_pool {
    name           = "default"
    node_count          = var.poolnodes
    vm_size        = var.vm_size
    vnet_subnet_id = azurerm_subnet.cluster-subnet.id
  }

  # Service principal settings
  service_principal {
    client_id     = var.sp_client_id
    client_secret = var.sp_client_secret
  }

  # Network settings
  network_profile {
    network_plugin     = "azure"
    dns_service_ip     = var.k8s_cni_dns_ip
    docker_bridge_cidr = var.k8s_cni_docker_bridge_range
    service_cidr       = var.k8s_cni_services_range

  }
}
