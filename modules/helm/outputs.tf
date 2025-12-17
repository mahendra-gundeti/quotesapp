output "release_name" {
  value       = helm_release.app.name
  description = "Name of the Helm release"
}

output "release_namespace" {
  value       = helm_release.app.namespace
  description = "Namespace of the Helm release"
}

output "release_version" {
  value       = helm_release.app.version
  description = "Version of the deployed Helm chart"
}

output "release_status" {
  value       = helm_release.app.status
  description = "Status of the Helm release"
}

output "namespace_name" {
  value       = var.create_namespace ? kubernetes_namespace.app_namespace[0].metadata[0].name : var.namespace
  description = "Name of the namespace"
}