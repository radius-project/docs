import radius as rad
param environment string
param application string

//BASIC
resource redis 'Applications.Link/redisCaches@2022-03-15-privatepreview'= {
  name: 'mylink'
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
resource redisParam 'Applications.Link/redisCaches@2022-03-15-privatepreview'= {
  name: 'mylink'
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
resource redisParam 'Applications.Link/redisCaches@2022-03-15-privatepreview'= {
  name: 'mylink'
  properties: {
    environment: environment
    application: application
  }
}
//DEFAULT
