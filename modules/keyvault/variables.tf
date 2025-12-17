variable "name" {
  type        = string
  description = "Name of the Key Vault"
}

variable "location" {
  type        = string
  description = "Azure region for the Key Vault"
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name"
}

variable "sku_name" {
  type        = string
  default     = "standard"
  description = "SKU name for Key Vault"
}

variable "secret_permissions" {
  type = list(string)
  default = [
    "Get",
    "List",
    "Set",
    "Delete",
    "Purge"
  ]
  description = "Secret permissions for the current user"
}

variable "additional_access_policies" {
  type = list(object({
    tenant_id          = string
    object_id          = string
    secret_permissions = list(string)
  }))
  default     = []
  description = "Additional access policies for the Key Vault"
}

variable "secrets" {
  type = map(object({
    length  = number
    special = bool
  }))
  default     = {}
  description = "Secrets to generate and store in Key Vault"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags to apply to resources"
}