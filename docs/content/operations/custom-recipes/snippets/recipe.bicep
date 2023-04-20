//RESOURCE
@description('Radius-provided object containing information about the resouce calling the Recipe')
param context object

resource azureCache 'Microsoft.Cache/redis@2022-06-01' = {
  // Ensure the resource name is unique and repeatable
  name: 'cache-${uniqueString(context.resource.id)}'
  properties: {
    sku: {
      capacity: 0
      family: 'C'
      name: 'Basic'
    }
  }
}
//RESOURCE

//OUTRESOURCE
output resource string = azureCache.id
//OUTRESOURCE

//OUTVALUES
output result object = {
  values: {
    host: azureCache.properties.hostName
    port: azureCache.properties.port
  }
  secrets: {
    connectionString: 'redis://${azureCache.properties.hostName}:${azureCache.properties.port}'
    #disable-next-line outputs-should-not-contain-secrets
    password: azureCache.listKeys().primaryKey
  }
}
//OUTVALUES
