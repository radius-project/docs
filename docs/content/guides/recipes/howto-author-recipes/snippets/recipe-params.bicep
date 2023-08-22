@description('The Azure region to deploy Azure resource(s) into. Defaults to the region of the target Azure resource group.')
param location string = resourceGroup().location

@description('Radius-provided object containing information about the resource calling the Recipe')
param context object

//RESOURCE
@minValue(0)
@maxValue(6)
@description('Capacity for the Azure Cache. Must be 0-6.')
param capacity int

resource azureCache 'Microsoft.Cache/redis@2022-06-01' = {
  name: 'cache-${uniqueString(context.resource.id)}'
  location: location
  properties: {
    sku: {
      capacity: capacity
      family: 'C'
      name: 'Basic'
    }
  }
}
//RESOURCE
