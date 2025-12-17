module "rg" {
  source      = "../../modules/resourcegroup"
  name        = "${var.name}-rg-${var.environment}"
  location    = var.location
  environment = var.environment
  owner       = var.owner
}