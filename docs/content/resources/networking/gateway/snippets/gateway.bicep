resource app 'radius.dev/Application@v1alpha3' = {
  name: 'myapp'

  //GATEWAY
  resource gateway 'Gateway' = {
    name: 'gateway'
    properties: {
      hostname: {
        // Ommiting hostname properties results in gatewayname.appname.PUBLIC_HOSTNAME_OR_IP.nip.io
        
        // Results in prefix.appname.PUBLIC_HOSTNAME_OR_IP.nip.io
        prefix: 'prefix'

        // Alternately you can specify your own hostname that you've configured externally
        fullyQualifiedHostname: 'hostname.radapp.dev'
      }
      routes: [
        {
          path: '/frontend'
          destination: frontendroute.id
        }
        {
          path: '/backend'
          destination: backendroute.id
        }
      ]
    }
  }
  //GATEWAY

  //FRONTENDROUTE
  resource frontendroute 'HttpRoute' = {
    name: 'frontendroute'
  }
  //FRONTENDROUTE

  //BACKENDROUTE
  resource backendroute 'HttpRoute' = {
    name: 'backendroute'
  }
  //BACKENDROUTE

  //FRONTEND
  resource frontend 'Container' = {
    name: 'frontend'
    properties: {
      container: {
        image: 'registry/container:tag'
        ports: {
          http: {
            containerPort: 3000
            provides: frontendroute.id
          }
        }
        env: {
          BACKEND_URL: backendroute.properties.url
        }
      }
      connections: {
        backend: {
          kind: 'Http'
          source: backendroute.id
        }
      }
    }
  }
  //FRONTEND

  //BACKEND
  resource backend 'Container' = {
    name: 'backend'
    properties: {
      container: {
        image: 'registry/container:tag'
        ports: {
          http: {
            containerPort: 8080
            provides: backendroute.id
          }
        }
      }
    }
  }
  //BACKEND
}
