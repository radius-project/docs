//RECIPE
extension radius

@description('Specifies the environment for resources.')
param environment string

@description('Specifies the application for resources.')
param application string

resource redis 'Applications.Datastores/redisCaches@2023-10-01-preview'= {
  name: 'myredis'
  properties: {
    environment: environment
    application: application
  }
}
//RECIPE
