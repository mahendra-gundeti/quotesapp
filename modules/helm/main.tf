resource "kubernetes_namespace" "app_namespace" {
  count = var.create_namespace ? 1 : 0

  metadata {
    name = var.namespace
    labels = {
      name = var.namespace
    }
  }
}

resource "helm_release" "app" {
  name       = var.release_name
  repository = var.repository_url  
  chart      = var.chart_name
  version    = var.chart_version
  namespace  = var.namespace

  create_namespace = var.create_namespace
  wait             = var.wait_for_deployment
  timeout          = var.timeout
  cleanup_on_fail  = var.cleanup_on_fail

  values = concat(
    var.values_files,
    [yamlencode(merge(var.helm_values, var.sensitive_values))]
  )

  depends_on = [kubernetes_namespace.app_namespace]
}
