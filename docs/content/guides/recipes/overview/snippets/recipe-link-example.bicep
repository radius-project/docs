extension radius
param environment string
param application string

//BASIC
resource redis 'Applications.Datastores/redisCaches@2023-10-01-preview'= {
  name: 'myresource'
  properties: {
    environment: environment
    application: application
    recipe: {
      name: 'azure-prod'
    }
  }
}
//BASIC


//PARAMETERS
resource redisParam 'Applications.Datastores/redisCaches@2023-10-01-preview'= {
  name: 'myresource'
  properties: {
    environment: environment
    application: application
    recipe: {
      name: 'azure-prod'
      parameters: {
        sku: 'Premium'
      }
    }
  }
}
//PARAMETERS

//DEFAULT
resource redisDefault 'Applications.Datastores/redisCaches@2023-10-01-preview'= {
  name: 'myresource'
  properties: {
    environment: environment
    application: application
  }
}
//DEFAULT
