import radius as radius

param environment string
param location string = resourceGroup().location
param cosmosDatabase resource 'Microsoft.DocumentDB/databaseAccounts/mongodbDatabases@2021-06-15'

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
        kind: 'mongo.com/MongoDB'
        source: db.id
      }
    }
  }
}
 
// Define database
resource db 'Applications.Connector/mongoDatabases@2022-03-15-privatepreview' = {
  name: 'db'
  properties: {
    application: app.id
    resource: cosmosDatabase.id 
  }
}
