// Import the set of Radius resources (Applications.*) into Bicep
extension radius
// Import the set of MyCompany resources (MyCompany.*) into Bicep
extension mycompany

param environment string

param application string

resource todolist 'Applications.Core/applications@2023-10-01-preview' = {
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
    application: application
    container: {
      image: 'ghcr.io/radius-project/samples/demo:latest'
      ports: {
        web: {
          containerPort: 3000
        }
      }
      env: {
        CONNECTION_POSTGRESQL_HOST: {
          value: postgres.properties.host
        }
        CONNECTION_POSTGRESQL_PORT: {
          value: string(postgres.properties.port)
        }
        CONNECTION_POSTGRESQL_USERNAME: {
          value: postgres.properties.username
        }
        CONNECTION_POSTGRESQL_DATABASE: {
          value: postgres.properties.database
        }
        CONNECTION_POSTGRESQL_PASSWORD: {
          value: postgres.properties.password
        }
      }
    }
  }
}
//CONNECTION

//POSTGRES
resource postgres 'Applications.Core/postgreSQL@2023-10-01-preview' = {
  name: 'postgres'
  location: 'global'
  properties: {
    application: application
    environment: environment 
  }
}
//POSTGRES



  

