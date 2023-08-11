resource azureResource 'Microsoft.Cache/redis@2022-06-01' existing = {
  name: 'mycache'
}

param svc object
param deployment object

//OUTVALUES
output result object = {
  resources: [
    '/planes/kubernetes/local/namespaces/${svc.metadata.namespace}/providers/core/Service/${svc.metadata.name}'
    '/planes/kubernetes/local/namespaces/${deployment.metadata.namespace}/providers/apps/Deployment/${deployment.metadata.name}'
  ]
  values: {
    host: '${svc.metadata.name}.${svc.metadata.namespace}.svc.cluster.local'
    port: 6379
  }
}
//OUTVALUES
