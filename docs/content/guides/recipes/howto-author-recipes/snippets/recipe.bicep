//RESOURCE
@description('Radius-provided object containing information about the resource calling the Recipe')
param context object

@description('The Azure region to deploy Azure resource(s) into. Defaults to the region of the target Azure resource group.')
param location string = resourceGroup().location

resource azureCache 'Microsoft.Cache/redis@2022-06-01' = {
  // Ensure the resource name is unique and repeatable
  name: 'cache-${uniqueString(context.resource.id)}'
  location: location
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
