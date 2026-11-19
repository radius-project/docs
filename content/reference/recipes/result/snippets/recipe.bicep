@description('Radius-provided object containing information about the resource calling the recipe')
param context object

// ... deploy your infrastructure here ...

// Example values produced by the infrastructure the recipe deploys.
var service = {
  metadata: {
    name: 'redis'
    namespace: context.runtime.kubernetes.namespace
  }
}
var password = 'example-password'

output result object = {
  // Resource IDs that Radius should track as part of this resource's lifecycle.
  resources: [
    '/planes/kubernetes/local/namespaces/${service.metadata.namespace}/providers/core/Service/${service.metadata.name}'
  ]
  // Non-sensitive values surfaced to the resource and its connections.
  values: {
    host: '${service.metadata.name}.${service.metadata.namespace}.svc.cluster.local'
    port: 6379
  }
  // Sensitive values stored securely as secrets.
  secrets: {
    #disable-next-line outputs-should-not-contain-secrets
    password: password
  }
}
