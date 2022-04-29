param ESHOP_EXTERNAL_DNS_NAME_OR_IP string = '*'
param CLUSTER_IP string
param OCHESTRATOR_TYPE string = 'K8S'
param APPLICATION_INSIGHTS_KEY string = ''
param AZURESTORAGEENABLED string = 'False'
param AZURESERVICEBUSENABLED string = 'True'
param ENABLEDEVSPACES string = 'False'
param TAG string = 'linux-dev'

var CLUSTERDNS = 'http://${CLUSTER_IP}.nip.io'
var PICBASEURL = '${CLUSTERDNS}/webshoppingapigw/c/api/v1/catalog/items/[0]/pic'

param adminLogin string = 'sqladmin'
@secure()
param adminPassword string

resource servicebus 'Microsoft.ServiceBus/namespaces@2021-06-01-preview' existing = {
  name: 'eshop${uniqueString(resourceGroup().id)}'

  resource topic 'topics' existing = {
    name: 'eshop_event_bus'

    resource rootRule 'authorizationRules' existing = {
      name: 'Root'
    }
  }

}

resource eshop 'radius.dev/Application@v1alpha3' existing = {
  name: 'eshop'

  // Based on https://github.com/dotnet-architecture/eShopOnContainers/tree/dev/deploy/k8s/helm/catalog-api
  resource catalog 'Container' = {
    name: 'catalog-api'
    properties: {
      container: {
        image: 'eshop/catalog.api:${TAG}'
        env: {
          UseCustomizationData: 'False'
          PATH_BASE: '/catalog-api'
          ASPNETCORE_ENVIRONMENT: 'Development'
          OrchestratorType: OCHESTRATOR_TYPE
          PORT: '80'
          GRPC_PORT: '81'
          PicBaseUrl: PICBASEURL
          AzureStorageEnabled: AZURESTORAGEENABLED
          ApplicationInsights__InstrumentationKey: APPLICATION_INSIGHTS_KEY
          AzureServiceBusEnabled: AZURESERVICEBUSENABLED
          ConnectionString: 'Server=tcp:${sqlCatalog.properties.server},1433;Initial Catalog=${sqlCatalog.properties.database};User Id=${adminLogin};Password=${adminPassword};'
          EventBusConnection: listKeys(servicebus::topic::rootRule.id, servicebus::topic::rootRule.apiVersion).primaryConnectionString
        }
        ports: {
          http: {
            containerPort: 80
            provides: catalogHttp.id
          }
          grpc: {
            containerPort: 81
          }
        }
      }
      connections: {
        sql: {
          kind: 'microsoft.com/SQL'
          source: sqlCatalog.id
        }
        servicebus: {
          kind: 'azure'
          source: servicebus.id
        }
      }
    }
  }

  resource catalogHttp 'HttpRoute' = {
    name: 'catalog-http'
    properties: {
      port: 5101
    }
  }

  resource catalogGrpc 'HttpRoute' = {
    name: 'catalog-grpc'
    properties: {
      port: 9101
    }
  }

  // Based on https://github.com/dotnet-architecture/eShopOnContainers/tree/dev/deploy/k8s/helm/identity-api
  resource identity 'Container' = {
    name: 'identity-api'
    properties: {
      container: {
        image: 'eshop/identity.api:${TAG}'
        env: {
          PATH_BASE: '/identity-api'
          ASPNETCORE_ENVIRONMENT: 'Development'
          ASPNETCORE_URLS: 'http://0.0.0.0:80'
          OrchestratorType: OCHESTRATOR_TYPE
          IsClusterEnv: 'True'
          DPConnectionString: '${redisKeystore.properties.host}:${redisKeystore.properties.port},password=${redisKeystore.password()},ssl=True,abortConnect=False'
          ApplicationInsights__InstrumentationKey: APPLICATION_INSIGHTS_KEY
          XamarinCallback: ''
          EnableDevspaces: ENABLEDEVSPACES
          ConnectionString: 'Server=tcp:${sqlIdentity.properties.server},1433;Initial Catalog=${sqlIdentity.properties.database};User Id=${adminLogin};Password=${adminPassword};Encrypt=true'
          MvcClient: 'http://${CLUSTERDNS}${webmvcHttp.properties.gateway.rules.webmvc.path.value}'
          SpaClient: CLUSTERDNS
          BasketApiClient: 'http://${CLUSTERDNS}${basketHttp.properties.gateway.rules.basket.path.value}'
          OrderingApiClient: 'http://${CLUSTERDNS}${orderingHttp.properties.gateway.rules.ordering.path.value}'
          WebShoppingAggClient: 'http://${CLUSTERDNS}${webshoppingaggHttp.properties.gateway.rules.webshoppingagg.path.value}'
          WebhooksApiClient: 'http://${CLUSTERDNS}${webhooksHttp.properties.gateway.rules.webhooks.path.value}'
          WebhooksWebClient: 'http://${CLUSTERDNS}${webhooksclientHttp.properties.gateway.rules.webhooks.path.value}'
        }
        ports: {
          http: {
            containerPort: 80
            provides: identityHttp.id
          }
        }
      }
      traits: []
      connections: {
        redis: {
          kind: 'redislabs.com/Redis'
          source: redisKeystore.id
        }
        sql: {
          kind: 'microsoft.com/SQL'
          source: sqlIdentity.id
        }
        webmvc: {
          kind: 'Http'
          source: webmvcHttp.id
        }
        webspa: {
          kind: 'Http'
          source: webspaHttp.id
        }
        basket: {
          kind: 'Http'
          source: basketHttp.id
        }
        ordering: {
          kind: 'Http'
          source: orderingHttp.id
        }
        webshoppingagg: {
          kind: 'Http'
          source: webshoppingaggHttp.id
        }
        webhooks: {
          kind: 'Http'
          source: webhooksHttp.id
        }
        webhooksclient: {
          kind: 'Http'
          source: webhooksclientHttp.id
        }
      }
    }
  }

  resource identityHttp 'HttpRoute' = {
    name: 'identity-http'
    properties: {
      port: 5105
    }
  }

  // Based on https://github.com/dotnet-architecture/eShopOnContainers/tree/dev/deploy/k8s/helm/ordering-api
  resource ordering 'Container' = {
    name: 'ordering-api'
    properties: {
      container: {
        image: 'eshop/ordering.api:${TAG}'
        env: {
          ASPNETCORE_ENVIRONMENT: 'Development'
          ASPNETCORE_URLS: 'http://0.0.0.0:80'
          UseCustomizationData: 'False'
          AzureServiceBusEnabled: 'True'
          CheckUpdateTime: '30000'
          ApplicationInsights__InstrumentationKey: APPLICATION_INSIGHTS_KEY
          OrchestratorType: OCHESTRATOR_TYPE
          UseLoadTest: 'False'
          'Serilog__MinimumLevel__Override__Microsoft.eShopOnContainers.BuildingBlocks.EventBusRabbitMQ': 'Verbose'
          'Serilog__MinimumLevel__Override__ordering-api': 'Verbose'
          PATH_BASE: '/ordering-api'
          GRPC_PORT: '81'
          PORT: '80'
          ConnectionString: 'Server=tcp:${sqlOrdering.properties.server},1433;Initial Catalog=${sqlOrdering.properties.database};User Id=${adminLogin};Password=${adminPassword};Encrypt=true'
          EventBusConnection: listKeys(servicebus::topic::rootRule.id, servicebus::topic::rootRule.apiVersion).primaryConnectionString
          identityUrl: identityHttp.properties.url
          IdentityUrlExternal: '${CLUSTERDNS}${identityHttp.properties.gateway.rules.identity.path.value}'
        }
        ports: {
          http: {
            containerPort: 80
            provides: orderingHttp.id
          }
          grpc: {
            containerPort: 81
            provides: orderingGrpc.id
          }
        }
      }
      traits: []
      connections: {
        sql: {
          kind: 'microsoft.com/SQL'
          source: sqlOrdering.id
        }
        identity: {
          kind: 'Http'
          source: identityHttp.id
        }
        servicebus: {
          kind: 'azure'
          source: servicebus.id
        }
      }
    }
  }

  resource orderingHttp 'HttpRoute' = {
    name: 'ordering-http'
    properties: {
      port: 5102
    }
  }

  resource orderingGrpc 'HttpRoute' = {
    name: 'ordering-grpc'
    properties: {
      port: 9102
    }
  }

  // Based on https://github.com/dotnet-architecture/eShopOnContainers/tree/dev/deploy/k8s/helm/basket-api
  resource basket 'Container' = {
    name: 'basket-api'
    properties: {
      container: {
        image: 'radius.azurecr.io/eshop-basket:linux-latest'
        env: {
          ASPNETCORE_ENVIRONMENT: 'Development'
          ASPNETCORE_URLS: 'http://0.0.0.0:80'
          ApplicationInsights__InstrumentationKey: APPLICATION_INSIGHTS_KEY
          UseLoadTest: 'False'
          PATH_BASE: '/basket-api'
          OrchestratorType: OCHESTRATOR_TYPE
          PORT: '80'
          GRPC_PORT: '81'
          AzureServiceBusEnabled: AZURESERVICEBUSENABLED
          ConnectionString: '${redisBasket.properties.host}:${redisBasket.properties.port},password=${redisBasket.password()},ssl=True,abortConnect=False,sslprotocols=tls12'
          EventBusConnection: listKeys(servicebus::topic::rootRule.id, servicebus::topic::rootRule.apiVersion).primaryConnectionString
          identityUrl: identityHttp.properties.url
          IdentityUrlExternal: '${CLUSTERDNS}${identityHttp.properties.gateway.rules.identity.path.value}'
        }
        ports: {
          http: {
            containerPort: 80
            provides: basketHttp.id
          }
          grpc: {
            containerPort: 81
            provides: basketGrpc.id
          }
        }
      }
      traits: []
      connections: {
        redis: {
          kind: 'redislabs.com/Redis'
          source: redisBasket.id
        }
        identity: {
          kind: 'Http'
          source: identityHttp.id
        }
        servicebus: {
          kind: 'azure'
          source: servicebus.id
        }
      }
    }
  }

  resource basketHttp 'HttpRoute' = {
    name: 'basket-http'
    properties: {
      port: 5103
    }
  }

  resource basketGrpc 'HttpRoute' = {
    name: 'basket-grpc'
    properties: {
      port: 9103
    }
  }

  // Based on https://github.com/dotnet-architecture/eShopOnContainers/tree/dev/deploy/k8s/helm/webhooks-api
  resource webhooks 'Container' = {
    name: 'webhooks-api'
    properties: {
      container: {
        image: 'eshop/webhooks.api:${TAG}'
        env: {
          ASPNETCORE_ENVIRONMENT: 'Development'
          ASPNETCORE_URLS: 'http://0.0.0.0:80'
          OrchestratorType: OCHESTRATOR_TYPE
          AzureServiceBusEnabled: AZURESERVICEBUSENABLED
          ConnectionString: 'Server=tcp:${sqlWebhooks.properties.server},1433;Initial Catalog=${sqlWebhooks.properties.database};User Id=${adminLogin};Password=${adminPassword};Encrypt=true'
          EventBusConnection: listKeys(servicebus::topic::rootRule.id, servicebus::topic::rootRule.apiVersion).primaryConnectionString
          identityUrl: identityHttp.properties.url
          IdentityUrlExternal: '${CLUSTERDNS}${identityHttp.properties.gateway.rules.identity.path.value}'
        }
        ports: {
          http: {
            containerPort: 80
            provides: webhooksHttp.id
          }
        }
      }
      traits: []
      connections: {
        sql: {
          kind: 'microsoft.com/SQL'
          source: sqlWebhooks.id
        }
        identity: {
          kind: 'Http'
          source: identityHttp.id
        }
        servicebus: {
          kind: 'azure'
          source: servicebus.id
        }
      }
    }
  }

  resource webhooksHttp 'HttpRoute' = {
    name: 'webhooks-http'
    properties: {
      port: 5113
    }
  }

  // Based on https://github.com/dotnet-architecture/eShopOnContainers/tree/dev/deploy/k8s/helm/payment-api
  resource payment 'Container' = {
    name: 'payment-api'
    properties: {
      container: {
        image: 'eshop/payment.api:${TAG}'
        env: {
          ASPNETCORE_ENVIRONMENT: 'Development'
          ASPNETCORE_URLS: 'http://0.0.0.0:80'
          ApplicationInsights__InstrumentationKey: APPLICATION_INSIGHTS_KEY
          'Serilog__MinimumLevel__Override__payment-api.IntegrationEvents.EventHandling': 'Verbose'
          'Serilog__MinimumLevel__Override__Microsoft.eShopOnContainers.BuildingBlocks.EventBusRabbitMQ': 'Verbose'
          OrchestratorType: OCHESTRATOR_TYPE
          AzureServiceBusEnabled: AZURESERVICEBUSENABLED
          EventBusConnection: listKeys(servicebus::topic::rootRule.id, servicebus::topic::rootRule.apiVersion).primaryConnectionString
        }
        ports: {
          http: {
            containerPort: 80
            provides: paymentHttp.id
          }
        }
      }
      traits: []
      connections: {
        servicebus: {
          kind: 'azure'
          source: servicebus.id
        }
      }
    }
  }

  resource paymentHttp 'HttpRoute' = {
    name: 'payment-http'
    properties: {
      port: 5108
    }
  }

  // Based on https://github.com/dotnet-architecture/eShopOnContainers/tree/dev/deploy/k8s/helm/ordering-backgroundtasks
  resource orderbgtasks 'Container' = {
    name: 'ordering-backgroundtasks'
    properties: {
      container: {
        image: 'eshop/ordering.backgroundtasks:${TAG}'
        env: {
          ASPNETCORE_ENVIRONMENT: 'Development'
          ASPNETCORE_URLS: 'http://0.0.0.0:80'
          PATH_BASE: '/ordering-backgroundtasks'
          UseCustomizationData: 'False'
          CheckUpdateTime: '30000'
          GracePeriodTime: '1'
          ApplicationInsights__InstrumentationKey: APPLICATION_INSIGHTS_KEY
          UseLoadTest: 'False'
          'Serilog__MinimumLevel__Override__Microsoft.eShopOnContainers.BuildingBlocks.EventBusRabbitMQ': 'Verbose'
          OrchestratorType: OCHESTRATOR_TYPE
          AzureServiceBusEnabled: AZURESERVICEBUSENABLED
          ConnectionString: 'Server=tcp:${sqlOrdering.properties.server},1433;Initial Catalog=${sqlOrdering.properties.database};User Id=${adminLogin};Password=${adminPassword};Encrypt=true'
          EventBusConnection: listKeys(servicebus::topic::rootRule.id, servicebus::topic::rootRule.apiVersion).primaryConnectionString
        }
        ports: {
          http: {
            containerPort: 80
            provides: orderbgtasksHttp.id
          }
        }
      }
      traits: []
      connections: {
        sql: {
          kind: 'microsoft.com/SQL'
          source: sqlOrdering.id
        }
        servicebus: {
          kind: 'azure'
          source: servicebus.id
        }
      }
    }
  }

  resource orderbgtasksHttp 'HttpRoute' = {
    name: 'orderbgtasks-http'
    properties: {
      port: 5111
    }
  }

  // Other ---------------------------------------------

  // Based on https://github.com/dotnet-architecture/eShopOnContainers/tree/dev/deploy/k8s/helm/webshoppingagg
  resource webshoppingagg 'Container' = {
    name: 'webshoppingagg'
    properties: {
      container: {
        image: 'eshop/webshoppingagg:${TAG}'
        env: {
          ASPNETCORE_ENVIRONMENT: 'Development'
          PATH_BASE: '/webshoppingagg'
          ASPNETCORE_URLS: 'http://0.0.0.0:80'
          OrchestratorType: OCHESTRATOR_TYPE
          urls__basket: basketHttp.properties.url
          urls__catalog: catalogHttp.properties.url
          urls__orders: orderingHttp.properties.url
          urls__identity: identityHttp.properties.url
          urls__grpcBasket: basketGrpc.properties.url
          urls__grpcCatalog: catalogGrpc.properties.url
          urls__grpcOrdering: orderingGrpc.properties.url
          CatalogUrlHC: '${catalogHttp.properties.url}/hc'
          OrderingUrlHC: '${orderingHttp.properties.url}/hc'
          IdentityUrlHC: '${identityHttp.properties.url}/hc'
          BasketUrlHC: '${basketHttp.properties.url}/hc'
          PaymentUrlHC: '${paymentHttp.properties.url}/hc'
          IdentityUrlExternal: '${CLUSTERDNS}${identityHttp.properties.gateway.rules.identity.path.value}'
        }
        ports: {
          http: {
            containerPort: 80
            provides: webshoppingaggHttp.id
          }
        }
      }
      traits: []
      connections: {
        identity: {
          kind: 'Http'
          source: identityHttp.id
        }
        ordering: {
          kind: 'Http'
          source: orderingHttp.id
        }
        catalog: {
          kind: 'Http'
          source: catalogHttp.id
        }
        basket: {
          kind: 'Http'
          source: basketHttp.id
        }
      }
    }
  }

  resource webshoppingaggHttp 'HttpRoute' = {
    name: 'webshoppingagg-http'
    properties: {
      port: 5121
    }
  }

  // Based on https://github.com/dotnet-architecture/eShopOnContainers/tree/dev/deploy/k8s/helm/apigwws
  resource webshoppingapigw 'Container' = {
    name: 'webshoppingapigw'
    properties: {
      container: {
        image: 'radius.azurecr.io/eshop-envoy:0.1.3'
        env: {}
        ports: {
          http: {
            containerPort: 80
            provides: webshoppingapigwHttp.id
          }
          http2: {
            containerPort: 8001
            provides: webshoppingapigwHttp2.id
          }
        }
      }
      traits: []
      connections: {}
    }
  }

  resource webshoppingapigwHttp 'HttpRoute' = {
    name: 'webshoppingapigw-http'
    properties: {
      port: 5202
    }
  }

  resource webshoppingapigwHttp2 'HttpRoute' = {
    name: 'webshoppingapigw-http-2'
    properties: {
      port: 15202
    }
  }

  // Based on https://github.com/dotnet-architecture/eShopOnContainers/tree/dev/deploy/k8s/helm/ordering-signalrhub
  resource orderingsignalrhub 'Container' = {
    name: 'ordering-signalrhub'
    properties: {
      container: {
        image: 'eshop/ordering.signalrhub:${TAG}'
        env: {
          ASPNETCORE_ENVIRONMENT: 'Development'
          ASPNETCORE_URLS: 'http://0.0.0.0:80'
          PATH_BASE: '/ordering-signalrhub'
          ApplicationInsights__InstrumentationKey: APPLICATION_INSIGHTS_KEY
          OrchestratorType: OCHESTRATOR_TYPE
          IsClusterEnv: 'True'
          AzureServiceBusEnabled: AZURESERVICEBUSENABLED
          EventBusConnection: listKeys(servicebus::topic::rootRule.id, servicebus::topic::rootRule.apiVersion).primaryConnectionString
          SignalrStoreConnectionString: '${redisKeystore.properties.host}:${redisKeystore.properties.port},password=${redisKeystore.password()},ssl=True,abortConnect=False'
          IdentityUrl: identityHttp.properties.url
          IdentityUrlExternal: '${CLUSTERDNS}${identityHttp.properties.gateway.rules.identity.path.value}'
        }
        ports: {
          http: {
            containerPort: 80
            provides: orderingsignalrhubHttp.id
          }
        }
      }
      traits: []
      connections: {
        redis: {
          kind: 'redislabs.com/Redis'
          source: redisKeystore.id
        }
        identity: {
          kind: 'Http'
          source: identityHttp.id
        }
        ordering: {
          kind: 'Http'
          source: orderingHttp.id
        }
        catalog: {
          kind: 'Http'
          source: catalogHttp.id
        }
        basket: {
          kind: 'Http'
          source: basketHttp.id
        }
        servicebus: {
          kind: 'azure'
          source: servicebus.id
        }
      }
    }
  }

  resource orderingsignalrhubHttp 'HttpRoute' = {
    name: 'orderingsignalrhub-http'
    properties: {
      port: 5112
    }
  }

  // Based on https://github.com/dotnet-architecture/eShopOnContainers/tree/dev/deploy/k8s/helm/webhooks-web
  resource webhooksclient 'Container' = {
    name: 'webhooks-client'
    properties: {
      container: {
        image: 'eshop/webhooks.client:${TAG}'
        env: {
          ASPNETCORE_ENVIRONMENT: 'Production'
          ASPNETCORE_URLS: 'http://0.0.0.0:80'
          PATH_BASE: '/webhooks-web'
          Token: 'WebHooks-Demo-Web'
          CallBackUrl: '${CLUSTERDNS}${webhooksclientHttp.properties.gateway.rules.webhooks.path.value}'
          SelfUrl: webhooksclientHttp.properties.url
          WebhooksUrl: webhooksHttp.properties.url
          IdentityUrl: '${CLUSTERDNS}${identityHttp.properties.gateway.rules.identity.path.value}'
        }
        ports: {
          http: {
            containerPort: 80
            provides: webhooksclientHttp.id
          }
        }
      }
      traits: []
      connections: {
        webhooks: {
          kind: 'Http'
          source: webhooksHttp.id
        }
        identity: {
          kind: 'Http'
          source: identityHttp.id
        }
      }
    }
  }

  resource webhooksclientHttp 'HttpRoute' = {
    name: 'webhooksclient-http'
    properties: {
      port: 5114
    }
  }

  // Sites ----------------------------------------------

  // Based on https://github.com/dotnet-architecture/eShopOnContainers/tree/dev/deploy/k8s/helm/webstatus
  resource webstatus 'Container' = {
    name: 'webstatus'
    properties: {
      container: {
        image: 'eshop/webstatus:${TAG}'
        env: {
          ASPNETCORE_ENVIRONMENT: 'Development'
          ASPNETCORE_URLS: 'http://0.0.0.0:80'
          PATH_BASE: '/webstatus'
          HealthChecksUI__HealthChecks__0__Name: 'WebMVC HTTP Check'
          HealthChecksUI__HealthChecks__0__Uri: '${webmvcHttp.properties.url}/hc'
          HealthChecksUI__HealthChecks__1__Name: 'WebSPA HTTP Check'
          HealthChecksUI__HealthChecks__1__Uri: '${webspaHttp.properties.url}/hc'
          HealthChecksUI__HealthChecks__2__Name: 'Web Shopping Aggregator GW HTTP Check'
          HealthChecksUI__HealthChecks__2__Uri: '${webshoppingaggHttp.properties.url}/hc'
          HealthChecksUI__HealthChecks__4__Name: 'Ordering HTTP Check'
          HealthChecksUI__HealthChecks__4__Uri: '${orderingHttp.properties.url}/hc'
          HealthChecksUI__HealthChecks__5__Name: 'Basket HTTP Check'
          HealthChecksUI__HealthChecks__5__Uri: '${basketHttp.properties.url}/hc'
          HealthChecksUI__HealthChecks__6__Name: 'Catalog HTTP Check'
          HealthChecksUI__HealthChecks__6__Uri: '${catalogHttp.properties.url}/hc'
          HealthChecksUI__HealthChecks__7__Name: 'Identity HTTP Check'
          HealthChecksUI__HealthChecks__7__Uri: '${identityHttp.properties.url}/hc'
          HealthChecksUI__HealthChecks__8__Name: 'Payments HTTP Check'
          HealthChecksUI__HealthChecks__8__Uri: '${paymentHttp.properties.url}/hc'
          HealthChecksUI__HealthChecks__9__Name: 'Ordering SignalRHub HTTP Check'
          HealthChecksUI__HealthChecks__9__Uri: '${orderingsignalrhubHttp.properties.url}/hc'
          HealthChecksUI__HealthChecks__10__Name: 'Ordering HTTP Background Check'
          HealthChecksUI__HealthChecks__10__Uri: '${orderbgtasksHttp.properties.url}/hc'
          ApplicationInsights__InstrumentationKey: APPLICATION_INSIGHTS_KEY
          OrchestratorType: OCHESTRATOR_TYPE
        }
        ports: {
          http: {
            containerPort: 80
            provides: webstatusHttp.id
          }
        }
      }
      traits: []
      connections: {}
    }
  }

  resource webstatusHttp 'HttpRoute' = {
    name: 'webstatus-http'
    properties: {
      port: 8107
    }
  }

  // Based on https://github.com/dotnet-architecture/eShopOnContainers/tree/dev/deploy/k8s/helm/webspa
  resource webspa 'Container' = {
    name: 'web-spa'
    properties: {
      container: {
        image: 'eshop/webspa:${TAG}'
        env: {
          PATH_BASE: '/'
          ASPNETCORE_ENVIRONMENT: 'Production'
          ASPNETCORE_URLS: 'http://0.0.0.0:80'
          UseCustomizationData: 'False'
          ApplicationInsights__InstrumentationKey: APPLICATION_INSIGHTS_KEY
          OrchestratorType: OCHESTRATOR_TYPE
          IsClusterEnv: 'True'
          CallBackUrl: '${CLUSTERDNS}/'
          DPConnectionString: '${redisKeystore.properties.host}:${redisKeystore.properties.port},password=${redisKeystore.password()},ssl=True,abortConnect=False'
          IdentityUrl: '${CLUSTERDNS}${identityHttp.properties.gateway.rules.identity.path.value}'
          IdentityUrlHC: '${identityHttp.properties.url}/hc'
          PurchaseUrl: '${CLUSTERDNS}${webshoppingapigwHttp.properties.gateway.rules.webshoppingapigw.path.value}'
          SignalrHubUrl: orderingsignalrhubHttp.properties.url
        }
        ports: {
          http: {
            containerPort: 80
            provides: webspaHttp.id
          }
        }
      }
      traits: []
      connections: {
        redis: {
          kind: 'redislabs.com/Redis'
          source: redisKeystore.id
        }
        webshoppingagg: {
          kind: 'Http'
          source: webshoppingaggHttp.id
        }
        identity: {
          kind: 'Http'
          source: identityHttp.id
        }
        webshoppingapigw: {
          kind: 'Http'
          source: webshoppingapigwHttp.id
        }
        orderingsignalrhub: {
          kind: 'Http'
          source: orderingsignalrhubHttp.id
        }
      }
    }
  }

  resource webspaHttp 'HttpRoute' = {
    name: 'webspa-http'
    properties: {
      port: 5104
    }
  }

  // Based on https://github.com/dotnet-architecture/eShopOnContainers/tree/dev/deploy/k8s/helm/webmvc
  resource webmvc 'Container' = {
    name: 'webmvc'
    properties: {
      container: {
        image: 'eshop/webmvc:${TAG}'
        env: {
          ASPNETCORE_ENVIRONMENT: 'Development'
          ASPNETCORE_URLS: 'http://0.0.0.0:80'
          PATH_BASE: '/webmvc'
          UseCustomizationData: 'False'
          ApplicationInsights__InstrumentationKey: APPLICATION_INSIGHTS_KEY
          UseLoadTest: 'False'
          DPConnectionString: '${redisKeystore.properties.host}:${redisKeystore.properties.port},password=${redisKeystore.password()},ssl=True,abortConnect=False'
          OrchestratorType: OCHESTRATOR_TYPE
          IsClusterEnv: 'True'
          CallBackUrl: '${CLUSTERDNS}${webmvcHttp.properties.gateway.rules.webmvc.path.value}'
          IdentityUrl: '${CLUSTERDNS}${identityHttp.properties.gateway.rules.identity.path.value}'
          IdentityUrlHC: '${identityHttp.properties.url}/hc'
          PurchaseUrl: webshoppingapigwHttp.properties.url
          ExternalPurchaseUrl: '${CLUSTERDNS}${webshoppingapigwHttp.properties.gateway.rules.webshoppingapigw.path.value}'
          SignalrHubUrl: orderingsignalrhubHttp.properties.url
        }
        ports: {
          http: {
            containerPort: 80
            provides: webmvcHttp.id
          }
        }
      }
      traits: []
      connections: {
        redis: {
          kind: 'redislabs.com/Redis'
          source: redisKeystore.id
        }
        webshoppingagg: {
          kind: 'Http'
          source: webshoppingaggHttp.id
        }
        identity: {
          kind: 'Http'
          source: identityHttp.id
        }
        webshoppingapigw: {
          kind: 'Http'
          source: webshoppingapigwHttp.id
        }
        orderingsignalrhub: {
          kind: 'Http'
          source: orderingsignalrhubHttp.id
        }
      }
    }
  }

  resource webmvcHttp 'HttpRoute' = {
    name: 'webmvc-http'
    properties: {
      port: 5100
    }
  }

  // Logging --------------------------------------------

  resource seq 'Container' = {
    name: 'seq'
    properties: {
      container: {
        image: 'datalust/seq:latest'
        env: {
          ACCEPT_EULA: 'Y'
        }
        ports: {
          web: {
            containerPort: 80
            provides: seqHttp.id
          }
        }
      }
      traits: []
      connections: {}
    }
  }

  resource seqHttp 'HttpRoute' = {
    name: 'seq-http'
    properties: {
      port: 5340
    }
  }

  // Gateway --------------------------------------------

  resource gateway 'Gateway' = {
    name: 'gateway'
    properties: {
      hostname: {
        fullyQualifiedHostname: CLUSTERDNS
      }
      routes: [
        {
          path: '/'
          destination: webspaHttp.id
        }
        {
          path: '/webshoppingagg'
          destination: webshoppingaggHttp.id
        }
        {
          path: '/webstatus'
          destination: webstatusHttp.id
        }
        {
          path: '/webhooks-web'
          destination: webhooksclientHttp.id
        }
        {
          path: '/webshoppingapigw'
          destination: webshoppingapigwHttp.id
        }
        {
          path: '/webmvc'
          destination: webmvcHttp.id
        }
        {
          path: '/webhooks-api'
          destination: webhooksHttp.id
        }
        {
          path: '/basket-api'
          desination: basketHttp.id
        }
        {
          path: '/ordering-api'
          destination: orderingHttp.id
        }
        {
          path: '/identity-api'
          destination: identityHttp.id
        }
      ]
    }
  }

  // Infrastructure --------------------------------------------

  resource sqlIdentity 'microsoft.com.SQLDatabase' existing = {
    name: 'IdentityDb'
  }

  resource sqlCatalog 'microsoft.com.SQLDatabase' existing = {
    name: 'CatalogDb'
  }

  resource sqlOrdering 'microsoft.com.SQLDatabase' existing = {
    name: 'OrderingDb'
  }

  resource sqlWebhooks 'microsoft.com.SQLDatabase' existing = {
    name: 'WebhooksDb'
  }

  resource redisBasket 'redislabs.com.RedisCache' existing = {
    name: 'basket-data'
  }

  resource redisKeystore 'redislabs.com.RedisCache' existing = {
    name: 'keystore-data'
  }

  resource mongo 'mongo.com.MongoDatabase' existing = {
    name: 'mongo'
  }
}
