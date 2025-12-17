variable "cluster_name" {
  type        = string
  description = "Name of the AKS cluster"
}

variable "location" {
  type        = string
  description = "Azure region for the AKS cluster"
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group"
}

variable "dns_prefix" {
  type        = string
  description = "DNS prefix for the AKS cluster"
}

variable "kubernetes_version" {
  type        = string
  default     = "1.28"
  description = "Kubernetes version"
}

variable "default_node_pool" {
  type = object({
    name                = string
    node_count          = number
    vm_size             = string
    subnet_id           = string
    os_disk_size_gb     = optional(number, 30)
    availability_zones  = optional(list(string), [])
  })
  description = "Default node pool configuration (auto-scaling not supported for default pool)"
}

variable "network_profile" {
  type = object({
    network_plugin    = optional(string, "azure")
    network_policy    = optional(string, "calico")
    service_cidr      = optional(string, "10.100.0.0/16")
    dns_service_ip    = optional(string, "10.100.0.10")
    load_balancer_sku = optional(string, "standard")
  })
  default = {
    network_plugin    = "azure"
    network_policy    = "calico"
    service_cidr      = "10.100.0.0/16"
    dns_service_ip    = "10.100.0.10"
    load_balancer_sku = "standard"
  }
  description = "Network profile configuration"
}

variable "additional_node_pools" {
  type = map(object({
    vm_size             = string
    node_count          = optional(number, 3)
    subnet_id           = string
    enable_auto_scaling = optional(bool, false)
    min_count           = optional(number, 1)
    max_count           = optional(number, 10)
    os_disk_size_gb     = optional(number, 30)
    availability_zones  = optional(list(string), [])
  }))
  default     = {}
  description = "Additional node pools configuration"
}

variable "vnet_id" {
  type        = string
  description = "Virtual network ID for network contributor role assignment"
}

variable "acr_id" {
  type        = string
  default     = null
  description = "Azure Container Registry ID for ACR pull role assignment"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags to apply to resources"
}