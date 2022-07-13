param CLUSTER_IP string
param OCHESTRATOR_TYPE string = 'K8S'
param APPLICATION_INSIGHTS_KEY string = ''
param AZURESTORAGEENABLED string = 'False'
param AZURESERVICEBUSENABLED string = 'False'
param ENABLEDEVSPACES string = 'False'
param TAG string = 'linux-dev'

var CLUSTERDNS = 'http://${CLUSTER_IP}.nip.io'
var PICBASEURL = '${CLUSTERDNS}/webshoppingapigw/c/api/v1/catalog/items/[0]/pic'

var tempRabbitmqConnectionString = 'eshop-starter-rabbitmq-route-${uniqueString('eshop_event_bus')}'

param adminLogin string = 'SA'
@secure()
param adminPassword string

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
          EventBusConnection: tempRabbitmqConnectionString
        }
        ports: {
          http: {
            containerPort: 80
            provides: catalogHttp.id
          }
          grpc: {
            containerPort: 81
            provides: catalogGrpc.id
          }
        }
      }
      connections: {
        sql: {
          kind: 'microsoft.com/SQL'
          source: sqlCatalog.id
        }
        rabbitmq: {
          kind: 'rabbitmq.com/MessageQueue'
          source: rabbitmq.id
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
          OrchestratorType: 'K8S'
          IsClusterEnv: 'True'
          DPConnectionString: '${redisKeystore.properties.host}'
          ApplicationInsights__InstrumentationKey: APPLICATION_INSIGHTS_KEY
          XamarinCallback: ''
          EnableDevspaces: ENABLEDEVSPACES
          ConnectionString: 'Server=tcp:${sqlIdentity.properties.server},1433;Initial Catalog=${sqlIdentity.properties.database};User Id=${adminLogin};Password=${adminPassword}'
          MvcClient: webmvcHttp.properties.url
          SpaClient: CLUSTERDNS
          BasketApiClient: basketHttp.properties.url
          OrderingApiClient: orderingHttp.properties.url
          WebShoppingAggClient: webshoppingaggHttp.properties.url
          WebhooksApiClient: webhooksHttp.properties.url
          WebhooksWebClient: webhooksclientHttp.properties.url
        }
        ports: {
          http: {
            containerPort: 80
            provides: identityHttp.id
          }
        }
      }
      extensions: []
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
        webhoolsclient: {
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
          AzureServiceBusEnabled: AZURESERVICEBUSENABLED
          CheckUpdateTime: '30000'
          ApplicationInsights__InstrumentationKey: APPLICATION_INSIGHTS_KEY
          OrchestratorType: OCHESTRATOR_TYPE
          UseLoadTest: 'False'
          'Serilog__MinimumLevel__Override__Microsoft.eShopOnContainers.BuildingBlocks.EventBusRabbitMQ': 'Verbose'
          'Serilog__MinimumLevel__Override__ordering-api': 'Verbose'
          PATH_BASE: '/ordering-api'
          GRPC_PORT: '81'
          PORT: '80'
          ConnectionString: 'Server=tcp:${sqlOrdering.properties.server},1433;Initial Catalog=${sqlOrdering.properties.database};User Id=${adminLogin};Password=${adminPassword}'
          EventBusConnection: tempRabbitmqConnectionString
          identityUrl: identityHttp.properties.url
          IdentityUrlExternal: '${CLUSTERDNS}/identity-api'
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
      extensions: []
      connections: {
        sql: {
          kind: 'microsoft.com/SQL'
          source: sqlOrdering.id
        }
        rabbitmq: {
          kind: 'rabbitmq.com/MessageQueue'
          source: rabbitmq.id
        }
        identity: {
          kind: 'Http'
          source: identityHttp.id
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
        image: 'eshop/basket.api:${TAG}'
        env: {
          ASPNETCORE_ENVIRONMENT: 'Development'
          ASPNETCORE_URLS: 'http://0.0.0.0:80'
          ApplicationInsights__InstrumentationKey: APPLICATION_INSIGHTS_KEY
          UseLoadTest: 'False'
          PATH_BASE: '/basket-api'
          OrchestratorType: 'K8S'
          PORT: '80'
          GRPC_PORT: '81'
          AzureServiceBusEnabled: AZURESERVICEBUSENABLED
          ConnectionString: '${redisBasket.properties.host}:${redisBasket.properties.port}'
          EventBusConnection: tempRabbitmqConnectionString
          identityUrl: identityHttp.properties.url
          IdentityUrlExternal: '${CLUSTERDNS}/identity-api'
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
      extensions: []
      connections: {
        redis: {
          kind: 'redislabs.com/Redis'
          source: redisBasket.id
        }
        rabbitmq: {
          kind: 'rabbitmq.com/MessageQueue'
          source: rabbitmq.id
        }
        identity: {
          kind: 'Http'
          source: identityHttp.id
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
        image: 'eshop/webhooks.api:linux-dev'
        env: {
          PATH_BASE: '/webhooks-api'
          ASPNETCORE_ENVIRONMENT: 'Development'
          ASPNETCORE_URLS: 'http://0.0.0.0:80'
          OrchestratorType: OCHESTRATOR_TYPE
          AzureServiceBusEnabled: AZURESERVICEBUSENABLED
          ConnectionString: 'Server=tcp:${sqlWebhooks.properties.server},1433;Initial Catalog=${sqlWebhooks.properties.database};User Id=${adminLogin};Password=${adminPassword}'
          EventBusConnection: tempRabbitmqConnectionString
          identityUrl: identityHttp.properties.url
          IdentityUrlExternal: '${CLUSTERDNS}/identity-api'
        }
        ports: {
          http: {
            containerPort: 80
            provides: webhooksHttp.id
          }
        }
      }
      extensions: []
      connections: {
        sql: {
          kind: 'microsoft.com/SQL'
          source: sqlWebhooks.id
        }
        rabbitmq: {
          kind: 'rabbitmq.com/MessageQueue'
          source: rabbitmq.id
        }
        identity: {
          kind: 'Http'
          source: identityHttp.id
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
        image: 'eshop/payment.api:linux-dev'
        env: {
          ApplicationInsights__InstrumentationKey: APPLICATION_INSIGHTS_KEY
          'Serilog__MinimumLevel__Override__payment-api.IntegrationEvents.EventHandling': 'Verbose'
          'Serilog__MinimumLevel__Override__Microsoft.eShopOnContainers.BuildingBlocks.EventBusRabbitMQ': 'Verbose'
          OrchestratorType: OCHESTRATOR_TYPE
          AzureServiceBusEnabled: AZURESERVICEBUSENABLED
          EventBusConnection: tempRabbitmqConnectionString
        }
        ports: {
          http: {
            containerPort: 80
            provides: paymentHttp.id
          }
        }
      }
      extensions: []
      connections: {
        rabbitmq: {
          kind: 'rabbitmq.com/MessageQueue'
          source: rabbitmq.id
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
        image: 'eshop/ordering.backgroundtasks:linux-dev'
        env: {
          ASPNETCORE_ENVIRONMENT: 'Development'
          ASPNETCORE_URLS: 'http://0.0.0.0:80'
          UseCustomizationData: 'False'
          CheckUpdateTime: '30000'
          GracePeriodTime: '1'
          ApplicationInsights__InstrumentationKey: APPLICATION_INSIGHTS_KEY
          UseLoadTest: 'False'
          'Serilog__MinimumLevel__Override__Microsoft.eShopOnContainers.BuildingBlocks.EventBusRabbitMQ': 'Verbose'
          OrchestratorType: OCHESTRATOR_TYPE
          AzureServiceBusEnabled: AZURESERVICEBUSENABLED
          ConnectionString: 'Server=tcp:${sqlOrdering.properties.server},1433;Initial Catalog=${sqlOrdering.properties.database};User Id=${adminLogin};Password=${adminPassword}'
          EventBusConnection: tempRabbitmqConnectionString
        }
        ports: {
          http: {
            containerPort: 80
            provides: orderbgtasksHttp.id
          }
        }
      }
      extensions: []
      connections: {
        sql: {
          kind: 'microsoft.com/SQL'
          source: sqlOrdering.id
        }
        rabbitmq: {
          kind: 'rabbitmq.com/MessageQueue'
          source: rabbitmq.id
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
          IsClusterEnv: 'True'
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
          IdentityUrlExternal: '${CLUSTERDNS}/identity-api'
        }
        ports: {
          http: {
            containerPort: 80
            provides: webshoppingaggHttp.id
          }
        }
      }
      extensions: []
      connections: {
        rabbitmq: {
          kind: 'rabbitmq.com/MessageQueue'
          source: rabbitmq.id
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
      extensions: []
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
          PATH_BASE: '/payment-api'
          ASPNETCORE_ENVIRONMENT: 'Development'
          ASPNETCORE_URLS: 'http://0.0.0.0:80'
          ApplicationInsights__InstrumentationKey: APPLICATION_INSIGHTS_KEY
          OrchestratorType: OCHESTRATOR_TYPE
          IsClusterEnv: 'True'
          AzureServiceBusEnabled: AZURESERVICEBUSENABLED
          EventBusConnection: tempRabbitmqConnectionString
          SignalrStoreConnectionString: '${redisKeystore.properties.host}'
          identityUrl: identityHttp.properties.url
          IdentityUrlExternal: '${CLUSTERDNS}/identity-api'
        }
        ports: {
          http: {
            containerPort: 80
            provides: orderingsignalrhubHttp.id
          }
        }
      }
      extensions: []
      connections: {
        redis: {
          kind: 'redislabs.com/Redis'
          source: redisKeystore.id
        }
        rabbitmq: {
          kind: 'rabbitmq.com/MessageQueue'
          source: rabbitmq.id
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
        image: 'eshop/webhooks.client:linux-dev'
        env: {
          ASPNETCORE_ENVIRONMENT: 'Production'
          ASPNETCORE_URLS: 'http://0.0.0.0:80'
          PATH_BASE: '/webhooks-web'
          Token: 'WebHooks-Demo-Web'
          CallBackUrl: '${CLUSTERDNS}/webhooks-web'
          SelfUrl: webhooksclientHttp.properties.url
          WebhooksUrl: webhooksHttp.properties.url
          IdentityUrl: identityHttp.properties.url
        }
        ports: {
          http: {
            containerPort: 80
            provides: webhooksclientHttp.id
          }
        }
      }
      extensions: []
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
      extensions: []
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
          DPConnectionString: '${redisKeystore.properties.host}'
          IdentityUrl: identityHttp.properties.url
          IdentityUrlHC: '${identityHttp.properties.url}/hc'
          PurchaseUrl: webshoppingapigwHttp.properties.url
          SignalrHubUrl: orderingsignalrhubHttp.properties.url
        }
        ports: {
          http: {
            containerPort: 80
            provides: webspaHttp.id
          }
        }
      }
      extensions: []
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
          DPConnectionString: '${redisKeystore.properties.host}'
          ApplicationInsights__InstrumentationKey: APPLICATION_INSIGHTS_KEY
          UseLoadTest: 'False'
          OrchestratorType: OCHESTRATOR_TYPE
          IsClusterEnv: 'True'
          ExternalPurchaseUrl: '${CLUSTERDNS}/webshoppingapigw'
          CallBackUrl: 'http://${CLUSTER_IP}.nip.io/webmvc'
          IdentityUrl: 'http://${CLUSTER_IP}.nip.io/identity-api'
          IdentityUrlHC: '${identityHttp.properties.url}/hc'
          PurchaseUrl: webshoppingapigwHttp.properties.url
          SignalrHubUrl: orderingsignalrhubHttp.properties.url
        }
        ports: {
          http: {
            containerPort: 80
            provides: webmvcHttp.id
          }
        }
      }
      extensions: []
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
      extensions: []
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
          destination: basketHttp.id
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
    name: 'identitydb'
  }

  resource sqlCatalog 'microsoft.com.SQLDatabase' existing = {
    name: 'catalogdb'
  }

  resource sqlOrdering 'microsoft.com.SQLDatabase' existing = {
    name: 'orderingdb'
  }

  resource sqlWebhooks 'microsoft.com.SQLDatabase' existing = {
    name: 'webhooksdb'
  }

  resource redisKeystore 'redislabs.com.RedisCache' existing = {
    name: 'keystore-data'
  }

  resource redisBasket 'redislabs.com.RedisCache' existing = {
    name: 'basket-data'
  }

  resource mongo 'mongo.com.MongoDatabase' existing = {
    name: 'mongo'
  }

  resource rabbitmq 'rabbitmq.com.MessageQueue' existing = {
    name: 'eshop_event_bus'
  }
}
