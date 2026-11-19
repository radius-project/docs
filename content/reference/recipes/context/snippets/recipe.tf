variable "context" {
  description = "Radius-provided object containing information about the resource calling the recipe"
  type        = any
}

locals {
  resource_name = var.context.resource.name
  namespace     = var.context.runtime.kubernetes.namespace
}
