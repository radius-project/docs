import radius as radius

@description('The ID of your Radius environment. Automatically injected by the rad CLI.')
param environment string

param cosmosDatabase string

resource app 'Applications.Core/applications@2022-03-15-privatepreview' = {
  name: 'cosmos-container-usermanaged'
  properties: {
    environment: environment
  }
}

//MONGO
resource db 'Applications.Link/mongoDatabases@2022-03-15-privatepreview' = {
  name: 'db'
  properties: {
    environment: environment
    application: app.id
    recipe: {
      // Name a specific recipe to use
      name: 'azure'
    }
  }
}
//MONGO
