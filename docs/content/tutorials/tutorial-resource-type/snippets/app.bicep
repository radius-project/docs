// Import the set of Radius resources (Applications.*) into Bicep
extension radius
// Import the set of MyCompany resources (MyCompany.*) into Bicep
extension mycompany

//APP
resource todolist 'Applications.Core/applications@2023-10-01-preview' = {
  name: 'todolist'
  properties: {
    environment: environment
  }
}
//APP

//POSTGRESQL
param environment string
resource postgresql 'MyCompany.Resources/postgreSQL@2023-10-01-preview' = {
  name: 'postgresql'
  location: 'global'
  properties: {
    application: todolist.id
    environment: environment
    size: 'S'
  }
}
//POSTGRESQL

//CONTAINER
resource demo 'Applications.Core/containers@2023-10-01-preview' = {
  name: 'demo'
  properties: {
    application: todolist.id
    container: {
      image: 'ghcr.io/radius-project/samples/demo:latest'
      ports: {
        web: {
          containerPort: 3000
        }
      }
      //CONNECTION
      env: {
        CONNECTION_POSTGRES_HOST: {
          value: postgresql.properties.host
        }
        CONNECTION_POSTGRES_PORT: {
          value: string(postgresql.properties.port)
        }
        CONNECTION_POSTGRES_USERNAME: {
          value: postgresql.properties.username
        }
        CONNECTION_POSTGRES_DATABASE: {
          value: postgresql.properties.database
        }
        //This is stored and passed as cleartext for demo purposes. In production, use a secret store.
        CONNECTION_POSTGRES_PASSWORD: {
          value: postgresql.properties.password
        }   
      }
    }
  }
}
//CONTAINER


