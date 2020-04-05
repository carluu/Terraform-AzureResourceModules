terraform {
  # Store state in Azure Blob account
  backend "azurerm" {
    resource_group_name  = "TerraformState"
    storage_account_name = "cuuterraformstate"
    container_name       = "terraform"
    key                  = "terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg-main" {
  name     = "rg-terraform-${var.name_suffix}"
  location = var.region
}

resource "azurerm_virtual_network" "vnet-main" {
  name                = var.core_network_name
  address_space       = ["${var.core_network_vnet_cidr}"]
  location            = var.region
  resource_group_name = azurerm_resource_group.rg-main.name
}


module "aks-linux-kubenet" {
  source           = "./modules/AKS/aks-linux-kubenet"
  name_suffix      = "test"
  region           = var.region
  poolnodes        = 1
  vm_size          = "Standard_D2s_v3"
  sp_client_id     = var.aks_sp_client_id
  sp_client_secret = var.aks_sp_client_secret
  mainrg = azurerm_resource_group.rg-main.name
}


module "aks-linux-cni" {
  source                      = "./modules/AKS/aks-linux-cni"
  name_suffix                 = "test"
  region                      = var.region
  poolnodes                   = 1
  vm_size                     = "Standard_D2s_v3"
  sp_client_id                = var.aks_sp_client_id
  sp_client_secret            = var.aks_sp_client_secret
  k8s_cni_startIp             = var.aks_k8s_cni_startIp
  k8s_cni_services_range      = var.aks_k8s_cni_services_range
  k8s_cni_docker_bridge_range = var.aks_k8s_cni_docker_bridge_range
  k8s_cni_dns_ip              = var.aks_k8s_cni_dns_ip
  mainrg = azurerm_resource_group.rg-main.name
  core_network_name = azurerm_virtual_network.vnet-main.name
}



module "adf-with-pipeline" {
  source      = "./modules/ADF/adf-with-pipeline"
  name_suffix = var.name_suffix
  region = var.region
  mainrg = azurerm_resource_group.rg-main.name
}


module "adb-workspace" {
  source      = "./modules/ADB/adb-workspace"
  name_suffix = var.name_suffix
  region      = var.region
  sku         = "premium"
  mainrg = azurerm_resource_group.rg-main.name
}

module "acr" {
  source      = "./modules/ACR/acr"
  name_suffix = var.name_suffix
  sku         = "standard"
  region = var.region
  mainrg = azurerm_resource_group.rg-main.name
}

module "sql-single-db" {
  source      = "./modules/SQL/single-db"
  name_suffix = var.name_suffix
  edition         = "basic"
  region = var.region
  mainrg = azurerm_resource_group.rg-main.name
  sql_server_pass = var.sql_server_pass
}

module "eventhub" {
  source      = "./modules/EventHub/eventhub"
  name_suffix = var.name_suffix
  sku         = "standard"
  region = var.region
  mainrg = azurerm_resource_group.rg-main.name
  capacity = 1
  partitions = 1
  retention = 1
}

module "storage-adlsg2" {
  source      = "./modules/Storage/storage-adlsg2"
  name_suffix = var.name_suffix
  region = var.region
  mainrg = azurerm_resource_group.rg-main.name
  replication = "LRS"
  tier = "Standard"
  kind = "StorageV2"
}

module "firewall" {
  source      = "./modules/Network/Firewall"
  name_suffix = var.name_suffix
  region = var.region
  mainrg = azurerm_resource_group.rg-main.name
  core_network_name = azurerm_virtual_network.vnet-main.name
  core_network_firewall_subnet_cidr = var.core_network_firewall_subnet_cidr
}
