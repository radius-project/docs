extension radius

@description('The ID of your Radius environment. Set automatically by the rad CLI.')
param environment string

@description('The ID of your Radius application. Set automatically by the rad CLI.')
param application string

resource extender 'Applications.Core/extenders@2023-10-01-preview' = {
  name: 'postgresql'
  properties: {
    environment: environment
    application: application
    recipe: {
      name: 'postgresql'
    }
  }
}

//CONTAINER
resource demo 'Applications.Core/containers@2023-10-01-preview' = {
  name: 'demo'
  properties: {
    application: application
    container: {
      image: 'ghcr.io/radius-project/samples/demo:latest'
      env: {
        POSTGRESQL_HOST: extender.properties.host
        POSTGRESQL_PORT: extender.properties.port
        POSTGRESQL_USERNAME: extender.properties.username
        POSTGRESQL_PASSWORD: extender.listSecrets().password
      }
      ports: {
        web: {
          containerPort: 3000
        }
      }
    }
    connections: {
      postgresql: {
        source: extender.id
      }
    }
  }
}
//CONTAINER
