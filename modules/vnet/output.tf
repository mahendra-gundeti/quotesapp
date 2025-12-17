output "id" {
  value       = azurerm_virtual_network.vnet.id
  description = "The virtual network configuration ID."
}

output "name" {
  value       = azurerm_virtual_network.vnet.name
  description = "The name of the virtual network."
}

output "location" {
  value       = azurerm_virtual_network.vnet.location
  description = "The location/region where the virtual network is created."
}

output "address_space" {
  value       = azurerm_virtual_network.vnet.address_space
  description = "The list of address spaces used by the virtual network."
}

output "subnets" {
  value       = { for subnet in azurerm_subnet.subnets : subnet.name => subnet }
  description = "Map of subnet configurations indexed by subnet name."
}

output "subnet_ids" {
  value       = { for subnet in azurerm_subnet.subnets : subnet.name => subnet.id }
  description = "Map of subnet IDs indexed by subnet name."
}

output "nsg_ids" {
  value       = { for key, nsg in azurerm_network_security_group.nsg : key => nsg.id }
  description = "Map of Network Security Group IDs indexed by subnet name."
}

output "vm_ids" {
  value       = { for key, vm in azurerm_linux_virtual_machine.vms : key => vm.id }
  description = "Map of virtual machine IDs indexed by VM configuration key."
}

output "vm_private_ips" {
  value       = { for key, nic in azurerm_network_interface.vm_nics : key => nic.ip_configuration[0].private_ip_address }
  description = "Map of private IP addresses for virtual machines indexed by VM configuration key."
}

output "vm_names" {
  value       = { for key, vm in azurerm_linux_virtual_machine.vms : key => vm.name }
  description = "Map of virtual machine names indexed by VM configuration key."
}

output "vm_public_ips" {
  value       = { for key, pip in azurerm_public_ip.public_ips : key => pip.ip_address }
  description = "Map of public IP addresses for virtual machines indexed by VM configuration key."
}