---
type: docs
title: "Reference: radius.compute/routes@2025-08-01-preview"
linkTitle: "routes"
description: "Detailed reference documentation for radius.compute/routes@2025-08-01-preview"
---

{{< schemaExample >}}

## Schema

## Description

The Radius.Compute/routes Resource Type defines network routes for responding to external clients. Note that a Routes resource is not required for service-to-service communication. To use Routes, define a Container and ensure a `containerPort` is specified.
```bicep
extension radius
param environment string

resource myApplication 'Radius.Core/applications@2025-08-01-preview' = { ... }

resource myContainer 'Radius.Compute/containers@2025-08-01-preview' = {
  name: 'myContainer'
  properties: {
    environment: environment
    application: myApplication.id
    containers: {
      frontend: {
        image: 'frontend:1.25'
        ports: {
          web: {
            containerPort: 8080
          }
        }
      }
      accounts: {
        image: 'accounts:1.25'
        ports: {
          web: {
            containerPort: 8080
          }
        }
      }
    }
  }
}
```

Then define a Routes resource.
```bicep
resource ingressRule 'Radius.Compute/routes@2025-08-01-preview' = {
  name: 'ingressRule'
  properties: {
    application: myApplication.id
    environment: environment
    kind: 'HTTP'
    rules: [
      {
        matches: [
          {
            httpPath: '/'
          }
        ]
        destinationContainer: {
          resourceId: myContainer.id
          containerName: 'frontend'
          containerPort: myContainer.properties.containers.frontend.ports.web.containerPort
        }
      }
    ]
  }
}
```

The hostname is determined by the Recipe. 

Multiple rules can be included in Routes.
```bicep
resource ingressRule 'Radius.Compute/routes@2025-08-01-preview' = {
  name: 'ingressRule'
  properties: {
    application: myApplication.id
    environment: environment
    kind: 'HTTP'
    rules: [
      {
        matches: [
          {
            httpPath: '/'
          }
        ]
        destinationContainer: {
          resourceId: myContainer.id
          containerName: 'frontend'
          containerPort: myContainer.properties.containers.frontend.ports.web.containerPort
        }
      }
      {
        matches: [
          {
            httpPath: '/accounts'
          }
        ]
        destinationContainer: {
          resourceId: myContainer.id
          containerName: 'accounts'
          containerPort: myContainer.properties.containers.accounts.ports.web.containerPort
        }
      }
    ]
  }
}
```

## Top-Level Properties

| Property | Type | Required | Read-Only | Description |
|----------|------|----------|-----------|-------------|
| `application` | string | true | false | (Required) The Radius Application ID. `myApplication.id` for example. |
| `codeReference` | string | false | false | Optional URI to the source code of this resource type. ex: https://github.com/radius-project/radius/blob/4fab87e8127adf1db6f43b7029d5235fbe82c5c9/cmd/controller/main.go#L27 |
| `connections` | [object](#connections) | false | false | Map of connection name to connection data. |
| `environment` | string | true | false | (Required) The Radius Environment ID. Typically set by the rad CLI. Typically value should be `environment`. |
| `hostnames` | string array | false | false | (Optional) Use only when kind is HTTP or TLS. When HTTP, match against the HTTP Host header. When using TLS, match against the SNI attribute of TLS ClientHello message. Hostname may be preceded by a * wildcard. |
| `kind` | string | false | false | (Optional) The type of rule. If not specified, `HTTPRoute` is assumed. `HTTPRoute` provides L7 ingress with support for matching based on the hostname and HTTP header. `TCPRoute` provides L4 ingress with no support for matching (all traffic is forwarded to the Container). `TLSRoute` provides L4 ingress with the ability to match based on Server Name Indication (SNI) which is equivalent to hostname in TLS. `UDPRoute` is similar to TCPRoutes but uses UDP.<br />Allowed values: `HTTP`, `TCP`, `TLS`, `UDP`. |
| `listener` | [object](#listener) | false | true | (Read Only) The Gateway Listener the route is assigned to. |
| `rules` | [object](#rules)[] | true | false | (Required) Rules define semantics for matching a network connection request based on conditions and forwarding the request to a Container. |

## Object Properties

### `connections` {#connections}

| Property | Type | Required | Read-Only | Description |
|----------|------|----------|-----------|-------------|
| `disableDefaultEnvVars` | boolean | false | false | Disables the automatic injection of environment variables from the connected resource's properties. |
| `source` | string | true | false | Resource ID of the source resource for this connection. |

### `listener` {#listener}

| Property | Type | Required | Read-Only | Description |
|----------|------|----------|-----------|-------------|
| `hostname` | string | false | false |  |
| `port` | integer | false | false |  |
| `protocol` | string | false | false | Allowed values: `HTTP`, `HTTPS`, `TCP`, `TLS`, `UDP`. |

### `rules` {#rules}

| Property | Type | Required | Read-Only | Description |
|----------|------|----------|-----------|-------------|
| `destinationContainer` | [object](#rules-destinationcontainer) | true | false |  |
| `matches` | [object](#rules-matches)[] | true | false | (Required) Matches define conditions used for matching a request. |

### `rules.destinationContainer` {#rules-destinationcontainer}

| Property | Type | Required | Read-Only | Description |
|----------|------|----------|-----------|-------------|
| `containerName` | string | true | false | (Required) The specific container to target within the Container resource. |
| `containerPort` | integer | true | false | (Required) The port to target from the container. |
| `resourceId` | string | true | false | (Required) The Radius Container resource ID. |

### `rules.matches` {#rules-matches}

| Property | Type | Required | Read-Only | Description |
|----------|------|----------|-----------|-------------|
| `httpHeaders` | [object](#rules-matches-httpheaders)[] | false | false | (Optional) HTTP headers to match. Specify only when kind is HTTP. Multiple match values are ANDed together. A request must match all the specified headers to match. |
| `httpMethod` | string | false | false | (Optional) The HTTP method to match. Specify only when kind is HTTP.<br />Allowed values: `CONNECT`, `DELETE`, `GET`, `HEAD`, `OPTIONS`, `PATCH`, `POST`, `PUT`, `TRACE`. |
| `httpPath` | string | false | false | (Optional) The HTTP request path to match. Trailing space is ignored. Requests for `/abc`, `/abc/`, and ``/abc/def/` will all match `/abc`. |
| `httpQueryParams` | [object](#rules-matches-httpqueryparams)[] | false | false | (Optional) HTTP query parameters to match. Specify only when kind is HTTP. |

### `rules.matches.httpHeaders` {#rules-matches-httpheaders}

| Property | Type | Required | Read-Only | Description |
|----------|------|----------|-----------|-------------|
| `name` | string | true | false | (Required) The name of the HTTP Header to be matched. Must be exact. |
| `value` | string | true | false | (Required) Value of HTTP Header to be matched. |

### `rules.matches.httpQueryParams` {#rules-matches-httpqueryparams}

| Property | Type | Required | Read-Only | Description |
|----------|------|----------|-----------|-------------|
| `name` | string | true | false | (Required) Name of the HTTP query parameter to be matched. Specify only when kind is HTTP. |
| `value` | string | true | false | (Required) Value of the HTTP query parameter to be matched. |
