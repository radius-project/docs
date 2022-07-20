import radius as radius

param environment string
param location string = resourceGroup().location
param cosmosDatabaseId string

// Define app 
resource app 'Applications.Core/applications@2022-03-15-privatepreview' = {
  name: 'webapp'
  location: location
  properties: {
    environment: environment
  }
}

// Define container resource to run app code
resource todoapplication 'Applications.Core/containers@2022-03-15-privatepreview' = {
  name: 'todoapp'
  location: location
  properties: {
    application: app.id
    container: {
      image: 'radius.azurecr.io/webapptutorial-todoapp'
      ports: {
        web: {
          containerPort: 3000
        }
      }
    }
    // Connect container to database 
    connections: {
      itemstore: {
        source: db.id
      }
    }
  }
}
 
// Define database
resource db 'Applications.Connector/mongoDatabases@2022-03-15-privatepreview' = {
  name: 'db'
  location: location
  properties: {
    environment: environment
    application: app.id
    resource: cosmosDatabaseId
  }
}
