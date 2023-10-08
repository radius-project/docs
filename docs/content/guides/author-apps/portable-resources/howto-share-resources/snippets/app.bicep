import radius as rad

@description('Environment ID of the Radius environment being deployed into. Injected automatically by the rad CLI.')
param environment string

resource sharedCache 'Applications.Datastores/redisCaches@2023-10-01-preview' = {
  name: 'shared-cache'
  properties: {
    environment: environment
    // No application property defined as this resource follows the lifecycle of the environment
  }
}
