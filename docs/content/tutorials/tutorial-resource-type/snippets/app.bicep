extension radius
// Import the set of MyCompany resources (MyCompany.*) into Bicep
extension mycompany

param environment string

param application string

//CONTAINER
resource demo 'Applications.Core/containers@2023-10-01-preview' = {
  name: 'demo'
  properties: {
    application: application
    container: {
      image: 'ghcr.io/radius-project/samples/demo:latest'
      ports: {
        web: {
          containerPort: 3000
        }
      }
      //CONNECTION
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
     //CONNECTION
    }
  }
}
//CONTAINER

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



  

