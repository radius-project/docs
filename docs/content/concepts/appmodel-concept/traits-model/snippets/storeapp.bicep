resource app 'radius.dev/Application@v1alpha3' = {
  name: 'shopping-app'

  resource store 'Container' = {
    name: 'storefront'
    properties: {
      container: {
        image: 'radius.azurecr.io/storefront'
        ports: {
          web: {
            containerPort: 80
            provides: storefrontHttp.id
          }
        }
      }
      connections: {
        inventory: {
          kind: 'dapr.io/StateStore'
          source: statestoreConnector.id
        }
      }
      traits: [
        {
          kind: 'dapr.io/Sidecar@v1alpha1'
          appPort: 3000
          appId: 'storefront'
          provides: storefrontDapr.id
        }
      ]
    }
    dependsOn: [
      statestore
    ]
  }

  resource storefrontDapr 'dapr.io.InvokeHttpRoute' = {
    name: 'storefront-dapr'
    properties: {
      appId: 'storefront'
    }
  }

  resource storefrontHttp 'HttpRoute' = {
    name: 'storefront-http'
    properties: {
      gateway: {
        hostname: 'example.com'
      }
    }
  }

  resource cart 'Container' = {
    name: 'cart-api'
    properties: {
      container: {
        image: 'radiusteam/cart-api'
        env: {
          STOREFRONT_ID: storefrontDapr.properties.appId
        }
      }
      connections: {
        store: {
          kind: 'dapr.io/InvokeHttp'
          source: storefrontDapr.id
        }
      }
      traits: [
        {
          kind: 'dapr.io/Sidecar@v1alpha1'
          appId: 'cart-api'
        }
      ]
    }
  }

  resource statestoreConnector 'dapr.io.StateStore' existing = {
    name: 'inventory'
  }
}

module statestore 'br:radius.azurecr.io/starters/dapr-statestore-azure-tablestorage:latest' = {
  name: 'statestore'
  params: {
    radiusApplication: app
    stateStoreName: 'inventory'
  }
}
