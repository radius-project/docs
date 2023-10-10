import radius as radius

@description('The ID of your Radius environment. Automatically injected by the rad CLI.')
param environment string

@description('The ID of your Radius application. Automatically injected by the rad CLI.')
param application string

//DB
resource db 'Applications.Datastores/redisCaches@2023-10-01-preview' = {
  name: 'db'
  properties: {
    environment: environment
    application: application
    recipe: {
      // Name a specific recipe to use
      name: 'azure'
    }
  }
}
//DB
