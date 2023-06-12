import radius as radius

@description('The ID of your Radius environment. Automatically injected by the rad CLI.')
param environment string

@description('The location of your resource.')
param location string

resource app 'Applications.Core/applications@2022-03-15-privatepreview' = {
  name: 'cosmos-container-usermanaged'
  properties: {
    environment: environment
  }
}

//MONGO
resource db 'Applications.Link/mongoDatabases@2022-03-15-privatepreview' = {
  name: 'db'
  location: location
  properties: {
    environment: environment
    application: app.id
    recipe: {
      // Name a specific Recipe to use
      name: 'azure-cosmosdb'
      // Set optional/required parameters (specific to the Recipe)
      parameters: {
        size: 'large'
      }
    }
  }
}
//MONGO