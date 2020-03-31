variable "name_suffix" {
  type = string
}


variable "vm_size" {
  type = string
}

variable "poolnodes" {
  type = number
}

variable "podspernode" {
  type    = number
  default = 30
}

variable "sp_client_id" {
  type = string
}

variable "sp_client_secret" {
  type = string
}
variable "k8s_cni_startIp" {
  type = string
}

variable "k8s_cni_services_range" {
  type = string
}

variable "k8s_cni_docker_bridge_range" {
  type = string
}

variable "k8s_cni_dns_ip" {
  type = string
}

variable "region" {
  type = string
}

variable "mainrg" {
  type = string
}
