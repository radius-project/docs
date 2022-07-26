import radius as radius

param environment string
param location string = resourceGroup().location
param cosmosDatabaseId string

//SNIPPET
// Infrastructure team provides database to the application team
param databaseId string

// Define application
resource app 'Applications.Core/applications@2022-03-15-privatepreview' = {
  name: 'myapp'
  location: location
  //PROPERTIES
  properties: {
    environment: environment
  }
  //PROPERTIES
}

// Define container resource to run app code
resource frontend 'Applications.Core/containers@2022-03-15-privatepreview' = {
  name: 'frontend'
  location: location
  properties: {
    application: app.id
    //CONTAINER
    container: {
      image: 'myregistry/frontend:latest'
      ports: {
        web: {
          containerPort: 3000
        }
      }
    }
    //CONTAINER
    // Connect container to database 
    connections: {
      itemstore: {
        source: databaseId
      }
    }
  }
}
//SNIPPET
