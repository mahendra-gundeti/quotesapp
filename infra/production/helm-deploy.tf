module "quotes_app" {
  source = "../../modules/helm"
  
  release_name     = "quotes-app-v2"
  chart_name       = "../../helm-charts"
  namespace        = "quotes"
  create_namespace = true
  
  values_files = [
    yamlencode({
      image = {
        repository = "mahendragundeti/quotesapp"
        tag        = "1.2.0"
      }
      service = {
        type = "LoadBalancer"
      }
      replicaCount = 3
      environment  = var.environment
      config = {
        database = {
          host     = module.postgresql.server_fqdn
          port     = "5432"
          name     = "quotesdb"
          user     = "postgres"
          sslMode  = "require"
          password = module.keyvault.secret_values["postgres-admin-password"]
        }
      }
    })
  ]
  
  depends_on = [module.aks, module.postgresql]
}