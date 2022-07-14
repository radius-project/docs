import radius as radius

param environmentId string

param location string = resourceGroup().location

param username string = 'admin'

param password string = newGuid()

resource app 'Applications.Core/applications@2022-03-15-privatepreview' = {
  name: 'todoapp'
  location: location
  properties: {
    environment: environmentId
  }
}
resource todoFrontend 'Applications.Core/containers@2022-03-15-privatepreview' = {
  name: 'frontend'
  location: location
  properties: {
    application: app.id
    container: {
      image: 'radius.azurecr.io/webapptutorial-todoapp'
      ports: {
        web: {
          containerPort: 3000
          provides: todoRoute.id
        }
      }
    }
    connections: {
      mongodb: {
        source: db.id
      }
    }
  }
}
resource todoRoute 'Applications.Core/httproutes@2022-03-15-privatepreview' = {
  name: 'frontend-route'
  location: location
  properties: {
    application: app.id
  }
}

resource todoGateway 'Applications.Core/gateways@2022-03-15-privatepreview' = {
  name: 'gateway'
  location: location
  properties: {
    application: app.id
    routes: [
      {
        path: '/'
        destination: todoRoute.id
      }
    ]
  }
}

resource mongoContainer 'Applications.Core/containers@2022-03-15-privatepreview' = {
  name: 'mongo-container-db'
  location: location
  properties: {
    application: app.id
    container: {
      image: 'mongo:4.2'
      env: {
        MONGO_INITDB_ROOT_USERNAME: username
        MONGO_INITDB_ROOT_PASSWORD: password
      }
      ports: {
        mongo: {
          containerPort: 27017
          provides: mongoRoute.id
        }
      }
    }
  }
}

resource mongoRoute 'Applications.Core/httproutes@2022-03-15-privatepreview' = {
  name: 'mongo-route-db'
  location: location
  properties: {
    application: app.id
    port: 27017
  }
}

resource db 'Applications.Connector/mongoDatabases@2022-03-15-privatepreview' = {
  name: 'db'
  location: location
  properties: {
    environment: environmentId
    secrets: {
      connectionString: 'mongodb://${username}:${password}@${mongoRoute.properties.hostname}:${mongoRoute.properties.port}'
      username: username
      password: password
    }
  }
}
