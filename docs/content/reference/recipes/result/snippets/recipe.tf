variable "context" {
  description = "Radius-provided object containing information about the resource calling the recipe"
  type        = any
}

locals {
  namespace = var.context.runtime.kubernetes.namespace
}

# ... deploy your infrastructure here ...

output "result" {
  # Mark the output sensitive because values and secrets are combined into one object.
  sensitive = true
  value = {
    # Resource IDs that Radius should track as part of this resource's lifecycle.
    resources = [
      "/planes/kubernetes/local/namespaces/${local.namespace}/providers/core/Service/${kubernetes_service.redis.metadata[0].name}"
    ]
    # Non-sensitive values surfaced to the resource and its connections.
    values = {
      host = "${kubernetes_service.redis.metadata[0].name}.${local.namespace}.svc.cluster.local"
      port = 6379
    }
    # Sensitive values stored securely as secrets.
    secrets = {
      password = random_password.password.result
    }
  }
}
