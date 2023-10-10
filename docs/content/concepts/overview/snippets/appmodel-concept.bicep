import radius as radius

param environment string

//SNIPPET
// Infrastructure operators provide database to the application team
param databaseId string

// Define application
resource app 'Applications.Core/applications@2023-10-01-preview' = {
  name: 'myapp'
  //PROPERTIES
  properties: {
    environment: environment
  }
  //PROPERTIES
}

// Define container resource to run app code
resource frontend 'Applications.Core/containers@2023-10-01-preview' = {
  name: 'frontend'
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
