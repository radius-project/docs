// Import the set of Radius resources (Applications.*) into Bicep
extension radius
// Import the set of MyCompany resources (MyCompany.*) into Bicep
extension mycompany

@description('The Radius Application ID. Injected automatically by the rad CLI.')
param application string

@description('The Radius environment. Injected automatically by the rad CLI.')
param environment string


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
          value: postgresql.properties.status.binding.host
        }
        CONNECTION_POSTGRESQL_PORT: {
          value: string(postgresql.properties.status.binding.port)
        }
        CONNECTION_POSTGRESQL_USERNAME: {
          value: postgresql.properties.status.binding.username
        }
        CONNECTION_POSTGRESQL_DATABASE: {
          value: postgresql.properties.status.binding.database
        }
        //This is passed as clear text for demo purposes only. In production, use a secret store.
        CONNECTION_POSTGRESQL_PASSWORD: {
          value: postgresql.properties.status.binding.password
        }   
      }
    }
  }
}
//CONTAINER

//POSTGRESQL
resource postgresql 'MyCompany.Resources/postgreSQL@2023-10-01-preview' = {
  name: 'postgresql'
  location: 'global'
  properties: {
    application: application
    environment: environment
  }
}
//POSTGRESQL
