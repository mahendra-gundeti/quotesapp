resource "azurerm_virtual_network" "vnet" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags
  address_space       = var.address_space
}

resource "azurerm_subnet" "subnets" {
  for_each             = var.subnets
  name                 = each.key
  resource_group_name  = azurerm_virtual_network.vnet.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = each.value.address_prefixes

  dynamic "delegation" {
  for_each = try(each.value.delegations, [])
  content {
    name = delegation.value.name
    service_delegation {
      name    = delegation.value.service
      actions = delegation.value.actions
    }
  }
}

  depends_on = [azurerm_virtual_network.vnet]
}

resource "azurerm_network_security_group" "nsg" {
  for_each            = { for k, v in var.subnets : k => v if coalesce(v.associate_nsg, false) }
  name                = "${var.name}-nsg-${each.key}"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags

  depends_on = [azurerm_virtual_network.vnet]

  dynamic "security_rule" {
    for_each = coalesce(each.value.nsg_rules, [])
    content {
      name                         = security_rule.value.name
      priority                     = security_rule.value.priority
      direction                    = security_rule.value.direction
      access                       = security_rule.value.access
      protocol                     = security_rule.value.protocol
      source_port_range            = try(security_rule.value.source_port_range, null)
      source_port_ranges           = try(security_rule.value.source_port_ranges, null)
      destination_port_range       = try(security_rule.value.destination_port_range, null)
      destination_port_ranges      = try(security_rule.value.destination_port_ranges, null)
      source_address_prefixes      = try(security_rule.value.source_address_prefixes, null)
      destination_address_prefixes = try(security_rule.value.destination_address_prefixes, null)
      source_address_prefix        = try(security_rule.value.source_address_prefix, null)
      destination_address_prefix   = try(security_rule.value.destination_address_prefix, null)
      description                  = try(security_rule.value.description, null)
    }
  }
}

resource "azurerm_subnet_network_security_group_association" "nsg_association" {
  for_each = azurerm_network_security_group.nsg

  subnet_id                 = azurerm_subnet.subnets[each.key].id
  network_security_group_id = each.value.id

  depends_on = [
    azurerm_subnet.subnets,
    azurerm_network_security_group.nsg,
    azurerm_virtual_network.vnet
  ]
  lifecycle {
    create_before_destroy = false
  }
}

resource "azurerm_network_interface" "vm_nics" {
  for_each            = var.vm_configs
  name                = "${var.name}-nic-${each.key}"
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnets[each.value.subnet_name].id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public_ips[each.key].id
  }

  depends_on = [
    azurerm_subnet.subnets,
    azurerm_public_ip.public_ips,
    azurerm_virtual_network.vnet
  ]
}
resource "azurerm_public_ip" "public_ips" {
  for_each            = var.vm_configs
  name                = "${var.name}-public-ip-${each.key}"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags
}

resource "azurerm_linux_virtual_machine" "vms" {
  for_each                        = var.vm_configs
  name                            = each.value.vm_name
  resource_group_name             = var.resource_group_name
  location                        = var.location
  size                            = each.value.vm_size
  admin_username                  = each.value.admin_username
  admin_password                  = each.value.admin_password
  disable_password_authentication = false
  tags                            = var.tags

  network_interface_ids = [azurerm_network_interface.vm_nics[each.key].id]

  admin_ssh_key {
    username   = each.value.admin_username
    public_key = file("~/.ssh/temp_id_rsa.pub")
  }


  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }
}
