// Import the set of Radius resources (Applications.*) into Bicep
import radius as radius

@description('The environment ID of your Radius application. Set automatically by the rad CLI.')
param environment string

resource app 'Applications.Core/applications@2022-03-15-privatepreview' = {
  name: 'myapp'
  properties: {
    environment: environment
  }
}

//CONTAINER
resource frontend 'Applications.Core/containers@2022-03-15-privatepreview' = {
  name: 'frontend'
  properties: {
    application: app.id
    container: {
      image: 'radius.azurecr.io/tutorial/demo:latest'
      env: {
        FOO: 'bar'
      }
      ports: {
        web: {
          containerPort: 3000
        }
      }
    }
    connections: {
      redis: {
        source: redis.id
      }
      backend: {
        source: 'http://backend:3000'
      }
    }
  }
}
//CONTAINER

//REDIS
resource redis 'Applications.Datastores/redisCaches@2022-03-15-privatepreview' = {
  name: 'redis'
  properties: {
    environment: environment
    application: app.id
  }
}
//REDIS

//BACKEND
resource backend 'Applications.Core/containers@2022-03-15-privatepreview' = {
  name: 'backend'
  properties: {
    application: app.id 
    container: {
      image: 'nginx:latest'
      ports: {
        api: {
          containerPort: 80
        }
      }
    }
  }
}
//BACKEND
