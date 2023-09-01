output "result" {
  value = {
    values = {
      host = "${kubernetes_service.metadata.name}.${kubernetes_service.metadata.namespace}.svc.cluster.local"
      port = kubernetes_service.spec.port[0].port
      username = ""
    }
    secrets = {
      password = ""
    }
    // UCP resource IDs
    resources = [
        "/planes/kubernetes/local/namespaces/${kubernetes_service.metadata.namespace}/providers/core/Service/${kubernetes_service.metadata.name}",
        "/planes/kubernetes/local/namespaces/${kubernetes_deployment.metadata.namespace}/providers/apps/Deployment/${kubernetes_deployment.metadata.name}"
    ]
  }
  description = "The result of the Recipe. Must match the target resource's schema."
  sensitive = true
}