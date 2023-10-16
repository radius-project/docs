//FRONTEND
import radius as rad

@description('The application ID being deployed. Injected automtically by the rad CLI')
param application string

resource demo 'Applications.Core/containers@2023-10-01-preview' = {
  name: 'demo'
  properties: {
    application: application
    container: {
      image: 'radius.azurecr.io/samples/demo:latest'
      ports: {
        web: {
          containerPort: 3000
        }
      }
    }
  }
}
//FRONTEND

//GATEWAY
resource gateway 'Applications.Core/gateways@2023-10-01-preview' = {
  name: 'gateway'
  properties: {
    application: application
    routes: [
      {
        path: '/'
        destination: 'http://${demo.name}:3000'
      }
    ]
  }
}
//GATEWAY
