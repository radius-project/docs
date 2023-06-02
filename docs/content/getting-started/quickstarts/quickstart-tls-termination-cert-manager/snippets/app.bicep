import radius as radius
param environment string

resource demoApplication 'Applications.Core/applications@2022-03-15-privatepreview' = {
  name: 'demo-application'
  properties: {
    environment: environment
  }
}

resource demoSecretStore 'Applications.Core/secretStores@2022-03-15-privatepreview' = {
  name: 'demo-secretstore'
  properties: {
    application: demoApplication.id
    type: 'certificate'
    data: {
      'tls.crt': {}
      'tls.key': {}
    }
    resource: 'default/demo-secret'
  }
}

resource demoGateway 'Applications.Core/gateways@2022-03-15-privatepreview' = {
  name: 'demo-gateway'
  properties: {
    application: demoApplication.id
    routes: [
      {
        path: '/'
        destination: demoRoute.id
      }
    ]
    tls: {
      certificateFrom: demoSecretStore.id
    }
  }
}

resource demoRoute 'Applications.Core/httpRoutes@2022-03-15-privatepreview' = {
  name: 'demo-route'
  properties: {
    application: demoApplication.id
  }
}

resource demoContainer 'Applications.Core/containers@2022-03-15-privatepreview' = {
  name: 'demo-container'
  properties: {
    application: demoApplication.id
    container: {
      image: 'radius.azurecr.io/tutorial/webapp:edge'
      ports: {
        web: {
          containerPort: 3000
          provides: demoRoute.id
        }
      }
    }
  }
}
