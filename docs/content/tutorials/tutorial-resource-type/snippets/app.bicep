// Import the set of Radius resources (Applications.*) into Bicep
extension radius

extension mycompany

param environment string

resource todoapp 'Applications.Core/applications@2023-10-01-preview' = {
  name: 'todoapp'
  location: 'global'
  properties: {
    environment: environment
  }
}

//CONNECTION
resource frontendcontainer 'Applications.Core/containers@2023-10-01-preview' = {
  name: 'frontendcontainer'
  properties: {
    application: todoapp.id
    container: {
      image: 'ghcr.io/radius-project/samples/demo:latest'
      ports: {
        web: {
          containerPort: 3000
        }
      }

      env: {
        CONNECTION_POSTGRES_HOST: {
          value: postgres.properties.status.binding.host
        }
        CONNECTION_POSTGRES_PORT: {
          value: string(postgres.properties.status.binding.port)
        }
        CONNECTION_POSTGRES_USERNAME: {
          value: postgres.properties.status.binding.username
        }
        CONNECTION_POSTGRES_DATABASE: {
          value: postgres.properties.status.binding.database
        }
        CONNECTION_POSTGRES_PASSWORD: {
          value: postgres.properties.status.binding.password
        }
      }
    }
  }
}
//CONNECTION

//POSTGRES
resource postgres 'MyCompany.Resources/postgreSQLDatabase@2023-10-01-preview' = {
  name: 'postgres'
  location: 'global'
  properties: {
    application: todoapp.id
    environment: environment 
  }
}
//POSTGRES



  

