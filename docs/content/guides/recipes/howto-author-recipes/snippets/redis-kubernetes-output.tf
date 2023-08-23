output "result" {
  value = {
    //LINKING
    // This workaround is needed because the deployment engine omits Kubernetes resources from its output.
    // Once this gap is addressed, users won't need to do this.
    resources = [
        "/planes/kubernetes/local/namespaces/${kubernetes_service.metadata.namespace}/providers/core/Service/${kubernetes_service.metadata.name}",
        "/planes/kubernetes/local/namespaces/${kubernetes_deployment.metadata.namespace}/providers/apps/Deployment/${kubernetes_deployment.metadata.name}"
    ]
    //LINKING
    values = {
      host = "test-host"
      port = 1234
      username = "test-username"
    }
    secrets = {
      password = "test-password"
    }
    sensitive = true
  }
}