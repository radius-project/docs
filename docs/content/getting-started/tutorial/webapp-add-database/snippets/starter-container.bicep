import radius as radius

param environment string

param location string = 'global'

param username string = 'admin'

param password string = newGuid()

resource app 'Applications.Core/applications@2022-03-15-privatepreview' = {
  name: 'todoapp'
  location: location
  properties: {
    environment: environment
  }
}

resource mongoContainer 'Applications.Core/containers@2022-03-15-privatepreview' = {
  name: 'starters-mongo-container-db'
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
  name: 'starters-mongo-route-db'
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
    environment: environment
    secrets: {
      connectionString: 'mongodb://${username}:${password}@${mongoRoute.properties.hostname}:${mongoRoute.properties.port}'
      username: username
      password: password
    }
  }
}
