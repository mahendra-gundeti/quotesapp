module "virtual_network" {
  source              = "../../modules/vnet"
  name                = "${var.name}-vnet-${var.environment}"
  resource_group_name = module.rg.name
  location            = module.rg.location
  address_space       = ["10.0.0.0/16"]
  tags                = {
    Environment = var.environment
    Owner       = var.owner
    Project     = var.name
  }
  subnets = {
    "web-subnet" = {
      address_prefixes = ["10.0.1.0/24"]
      associate_nsg    = true
      nsg_rules = [
        {
          name                       = "Allow-SSH"
          priority                   = 1001
          direction                  = "Inbound"
          access                     = "Allow"
          protocol                   = "Tcp"
          source_port_range          = "*"
          destination_port_range     = "22"
          source_address_prefix      = "*"
          destination_address_prefix = "*"
          description                = "Allow SSH from trusted IP"
        }
      ]
  }
    "db-subnet" = {
      address_prefixes = ["10.0.2.0/24"]
      delegations = [
      {
        name    = "postgresql-flexible-server"
        service = "Microsoft.DBforPostgreSQL/flexibleServers"
        actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
      }]
      associate_nsg    = true
      nsg_rules = [
        {
          name                       = "Allow-Postgres-From-WebSubnet"
          priority                   = 1001
          direction                  = "Inbound"
          access                     = "Allow"
          protocol                   = "Tcp"
          source_port_range          = "*"
          destination_port_range     = "5432"
          source_address_prefix      = "10.0.1.0/24"
          destination_address_prefix = "*"
          description                = "Allow Postgres from web subnet"
        },
        {
          name                       = "Allow-Postgres-From-K8sSubnet"
          priority                   = 1002
          direction                  = "Inbound"
          access                     = "Allow"
          protocol                   = "Tcp"
          source_port_range          = "*"
          destination_port_range     = "5432"
          source_address_prefix      = "10.0.32.0/19"
          destination_address_prefix = "*"
          description                = "Allow Postgres from Kubernetes subnet"
        }
      ]
    }
    "k8s-subnet" = {
      address_prefixes = ["10.0.32.0/19"]
      associate_nsg    = true
      nsg_rules = [
        {
          name                       = "Allow-K8s-API"
          priority                   = 1001
          direction                  = "Inbound"
          access                     = "Allow"
          protocol                   = "Tcp"
          source_port_range          = "*"
          destination_port_range     = "443"
          source_address_prefix      = "10.0.0.0/16"
          destination_address_prefix = "*"
          description                = "Allow Kubernetes API access"
        },{
          name                       = "Allow-http-traffic"
          priority                   = 1002
          direction                  = "Inbound"
          access                     = "Allow"
          protocol                   = "Tcp"
          source_port_range          = "*"
          destination_port_range     = "80"
          source_address_prefix      = "*"
          destination_address_prefix = "*"
          description                = "Allow HTTP traffic"
        },
        {
          name                       = "Allow-K8s-To-DB"
          priority                   = 1003
          direction                  = "Outbound"
          access                     = "Allow"
          protocol                   = "Tcp"
          source_port_range          = "*"
          destination_port_range     = "5432"
          source_address_prefix      = "*"
          destination_address_prefix = "10.0.2.0/24"
          description                = "Allow Kubernetes to access PostgreSQL"
        }
      ]
    }
  }
  vm_configs = {
        "web-vm" = {
        vm_name        = "web-server"
        vm_size        = "Standard_F2s"
        admin_username = "quotesadmin"
        admin_password = module.keyvault.secret_values["vm-admin-password"]
        subnet_name    = "web-subnet"
        }
    }
}