import radius as radius

param environment string

resource app 'Applications.Core/applications@2022-03-15-privatepreview' = {
  name: 'myapp'
  location: 'global'
  properties: {
    environment: environment
  }
}

resource serviceA 'Applications.Core/containers@2022-03-15-privatepreview' = {
  name: 'service-a'
  location: 'global'
  properties: {
    application: app.id
    container: {
      image: 'servicea'
      ports: {
        web: {
          containerPort: 80
          provides: routeAWeb.id
        }
        api: {
          containerPort: 3000
          provides: routeAApi.id
        }
      }
    }
    connections: {
      serviceB: {
        source: routeB.id
      }
    }
  }
}

resource routeAWeb 'Applications.Core/httpRoutes@2022-03-15-privatepreview' = {
  name: 'route-a-web'
  location: 'global'
  properties: {
    application: app.id
  }
}

resource routeAApi 'Applications.Core/httpRoutes@2022-03-15-privatepreview' = {
  name: 'route-a-api'
  location: 'global'
  properties: {
    application: app.id
  }
}

resource serviceB 'Applications.Core/containers@2022-03-15-privatepreview' = {
  name: 'service-b'
  location: 'global'
  properties: {
    application: app.id
    container: {
      image: 'serviceb'
      ports: {
        api: {
          containerPort: 3000
          provides: routeB.id
        }
      }
    }
    connections: {
      serviceA: {
        source: routeAApi.id
      }
    }
  }
}

resource routeB 'Applications.Core/httpRoutes@2022-03-15-privatepreview' = {
  name: 'route-b'
  location: 'global'
  properties: {
    application: app.id
  }
}

resource internetGateway 'Applications.Core/gateways@2022-03-15-privatepreview' = {
  name: 'internet-gateway'
  location: 'global'
  properties: {
    application: app.id
    routes: [
      {
        path: '/'
        destination: routeAWeb.id
      }
    ]
  }
}
