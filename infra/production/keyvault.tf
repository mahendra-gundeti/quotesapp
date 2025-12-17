module "keyvault" {
  source              = "../../modules/keyvault"
  name                = "${var.name}-kv-${var.environment}"
  location            = module.rg.location
  resource_group_name = module.rg.name
  
  secrets = {
    "postgres-admin-password" = {
      length  = 16
      special = true
    }
    "vm-admin-password" = {
      length  = 16
      special = true
    }
  }

  tags = {
    Environment = var.environment
    Owner       = var.owner
    Project     = var.name
  }
}