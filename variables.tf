variable "aks_sp_client_id" {
  type = string
}

variable "aks_sp_client_secret" {
  type = string
}

variable "aks_k8s_cni_startIp" {
  type = string
}

variable "aks_k8s_cni_services_range" {
  type = string
}

variable "aks_k8s_cni_docker_bridge_range" {
  type = string
}

variable "aks_k8s_cni_dns_ip" {
  type = string
}

variable "name_suffix" {
  type = string
}

variable "region" {
  type = string
}

variable "sql_server_pass" {
  type = string
}

variable "core_network_name" {
  type = string
}

variable "core_network_vnet_cidr" {
  type = string
}

variable "core_network_default_subnet_cidr" {
  type = string
}

variable "core_network_serviceendpoints_subnet_cidr" {
  type = string
}

variable "core_network_firewall_subnet_cidr" {
  type = string
}
