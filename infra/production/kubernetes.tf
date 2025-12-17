module "aks" {
  source              = "../../modules/aks"
  cluster_name        = "${var.name}-aks-${var.environment}"
  location            = module.rg.location
  resource_group_name = module.rg.name
  dns_prefix          = "${var.name}-aks-${var.environment}"
  kubernetes_version  = "1.32"
  
  default_node_pool = {
    name               = "default"
    node_count         = 3
    vm_size            = "Standard_B2s"
    subnet_id          = module.virtual_network.subnet_ids["k8s-subnet"]
  }

  
  network_profile = {
    network_plugin    = "azure"
    network_policy    = "calico"
    service_cidr      = "10.100.0.0/16"
    dns_service_ip    = "10.100.0.10"
    load_balancer_sku = "standard"
  }
  
  vnet_id = module.virtual_network.id
  
  tags = {
    Environment = var.environment
    Owner       = var.owner
    Project     = var.name
  }
}
