import radius as radius

param location string = resourceGroup().location
param environment string

resource app 'Applications.Core/applications@2022-03-15-privatepreview' = {
  name: 'myapp'
  location: location
  properties: {
    environment: environment
  }
}

resource serviceA 'Container' = {
  name: 'service-a'
  location: location
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
        kind: 'Http'
        source: routeB.id
      }
    }
  }
}

resource routeAWeb 'HttpRoute' = {
  name: 'route-a-web'
  location: location
  properties: {
    application: app.id
  }
}

resource routeAApi 'HttpRoute' = {
  name: 'route-a-api'
  location: location
  properties: {
    application: app.id
  }
}

resource serviceB 'Container' = {
  name: 'service-b'
  location: location
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
        kind: 'Http'
        source: routeAApi.id
      }
    }
  }
}

resource routeB 'HttpRoute' = {
  name: 'route-b'
  location: location
  properties: {
    application: app.id
  }
}

resource internetGateway 'Gateway' = {
  name: 'internet-gateway'
  location: location
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
