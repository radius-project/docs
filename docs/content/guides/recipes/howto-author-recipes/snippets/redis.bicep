extension radius

param environment string

param application string

//REDIS
resource redis 'Applications.Datastores/redisCaches@2023-10-01-preview'= {
  name: 'myresource'
  properties: {
    environment: environment
    application: application
    recipe: {
      name: 'myrecipe'
    }
  }
}
//REDIS


