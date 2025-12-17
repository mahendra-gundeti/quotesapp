module "postgresql" {
  source                = "../../modules/sqldatabase"
  server_name           = "${var.name}-postgres-${var.environment}"
  resource_group_name   = module.rg.name
  location              = module.rg.location
  admin_username        = "postgres"
  admin_password        = module.keyvault.secret_values["postgres-admin-password"]
  postgres_version      = "17"
  sku_name              = "B_Standard_B1ms" 
  storage_mb            = 32768
  backup_retention_days = 7
  delegated_subnet_id   = module.virtual_network.subnet_ids["db-subnet"]
  virtual_network_id    = module.virtual_network.id
  databases             = ["quotesdb"]
  tags                = {
    Environment = var.environment
    Owner       = var.owner
    Project     = var.name
  }
}
