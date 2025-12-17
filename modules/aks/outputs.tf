output "cluster_id" {
  value       = azurerm_kubernetes_cluster.main.id
  description = "AKS cluster ID"
}

output "cluster_name" {
  value       = azurerm_kubernetes_cluster.main.name
  description = "AKS cluster name"
}

output "cluster_fqdn" {
  value       = azurerm_kubernetes_cluster.main.fqdn
  description = "AKS cluster FQDN"
}

output "kube_config" {
  value       = azurerm_kubernetes_cluster.main.kube_config_raw
  description = "Raw kubeconfig for the AKS cluster"
  sensitive   = true
}

output "client_certificate" {
  value       = azurerm_kubernetes_cluster.main.kube_config[0].client_certificate
  description = "Client certificate for cluster access"
  sensitive   = true
}

output "client_key" {
  value       = azurerm_kubernetes_cluster.main.kube_config[0].client_key
  description = "Client key for cluster access"
  sensitive   = true
}

output "cluster_ca_certificate" {
  value       = azurerm_kubernetes_cluster.main.kube_config[0].cluster_ca_certificate
  description = "Cluster CA certificate"
  sensitive   = true
}

output "host" {
  value       = azurerm_kubernetes_cluster.main.kube_config[0].host
  description = "Kubernetes API server host"
  sensitive   = true
}

output "identity_principal_id" {
  value       = azurerm_kubernetes_cluster.main.identity[0].principal_id
  description = "Principal ID of the AKS cluster identity"
}

output "kubelet_identity_object_id" {
  value       = azurerm_kubernetes_cluster.main.kubelet_identity[0].object_id
  description = "Object ID of the kubelet identity"
}