variable "server_name" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "admin_username" {
  type    = string
  default = "psqladmin"
}

variable "admin_password" {
  type      = string
  sensitive = true
}

variable "postgres_version" {
  type    = string
  default = "15"
}

variable "sku_name" {
  type    = string
  default = "B_Standard_B1ms"
}

variable "storage_mb" {
  type = number
}

variable "backup_retention_days" {
  type = number
}

variable "databases" {
  type = list(string)
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "delegated_subnet_id" {
  type = string
  description = "The ID of the delegated subnet for PostgreSQL Flexible Server."
}

variable "virtual_network_id" {
  type = string
  description = "The ID of the virtual network for private DNS zone link."
}