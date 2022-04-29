param app object
param backendHttp object

resource myapp 'radius.dev/Application@v1alpha3' existing = {
  name: app.name

  resource frontendHttp 'HttpRoute' = {
    name: 'frontend-http'
    properties: {
      port: 80
    }
  }

  resource gateway 'Gateway' = {
    name: 'gateway'
    properties: {
      routes: [
        {
          path: '/'
          destination: frontendHttp.id
        }
      ]
    }
  }

  resource frontend 'Container' = {
    name: 'frontend'
    properties: {
      container: {
        image: 'nginx:latest'
      }
      connections: {
        backend: {
          kind: 'Http'
          source: backendHttp.id
        }
      }
    }
  }

}
