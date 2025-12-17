variable "name" {
  type        = string
  description = "The name of the virtual network."
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group in which to create the virtual network."
}

variable "location" {
  type        = string
  description = "The location/region where the virtual network is created."
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "A mapping of tags to assign to the resource."
}

variable "address_space" {
  type        = list(string)
  description = "The address space that is used in the virtual network."
}

variable "subnets" {
  type = map(object({
    address_prefixes = list(string)
    delegations      = optional(list(object({
      name    = string
      service = string
      actions = list(string)
    })), [])
    nsg_rules        = optional(list(object({
      name                         = string
      priority                     = number
      direction                    = string
      access                       = string
      protocol                     = string
      source_port_range            = optional(string)
      source_port_ranges           = optional(list(string))
      destination_port_range       = optional(string)
      destination_port_ranges      = optional(list(string))
      source_address_prefixes      = optional(list(string))
      destination_address_prefixes = optional(list(string))
      source_address_prefix        = optional(string)
      destination_address_prefix   = optional(string)
      description                  = optional(string)
    })))
    associate_nsg    = optional(bool, false)
  }))
  default     = {}
  description = "Map of subnet configurations indexed by subnet name."
}

variable "vm_configs" {
  type = map(object({
    subnet_name    = string
    vm_name        = string
    vm_size        = optional(string, "Standard_B1s")
    admin_username = optional(string, "adminuser")
    admin_password = optional(string)
  }))
  default     = {}
  description = "Map of virtual machine configurations indexed by VM identifier"
}