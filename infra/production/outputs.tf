output "vm_public_ip" {
  value       = module.virtual_network.vm_public_ips["web-vm"]
  description = "The public IP address of the virtual machine."
}