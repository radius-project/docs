---
type: docs
title: "Concept: Technical walkthrough"
linkTitle: "Walkthrough"
description: "Take a tour of Radius, focusing on the technical concepts"
weight: 300
categories: "Concept"
---

Let's take a technical, deep dive into Radius. This walkthrough will focus on the [Radius getting started guide]({{< ref getting-started >}}), but go deeper into what's happening "under the hood" in Radius. This guide is intended for developers and platform engineers that want to understand how Radius works and what happens both on your local machine and in your Kubernetes cluster when you use Radius.

## Installing the rad CLI

The [rad CLI]({{< ref "/guides/tooling/rad-cli/overview" >}}) is the primary way to interact with your Radius installation and your Radius resources (_environments, recipes, applications, etc._). The rad CLI is written in Go and is available for Linux, macOS, and Windows.

{{< read file= "/shared-content/installation/rad-cli/install-rad-cli.md" >}}

Running these installation scripts will determine the latest stable release version in GitHub, download the appropriate binary for your operating system from the GitHub release, and install it in your `$PATH`.

- For Windows, this will be in `%LOCALAPPDATA%\radius\rad.exe` (_resolves to something like `C:\Users\john\AppData\Local\radius`_)
- For Linux and macOS, this will be in `/usr/local/bin/rad`

For more information on how the installation script works (_and to contribute to it!_), see the [install.sh](https://github.com/radius-project/radius/blob/main/deploy/install.sh) and [install.ps1](https://github.com/radius-project/radius/blob/main/deploy/install.ps1) scripts.

After running the script above, you will be able to run the `rad` command from your terminal.

## Initializing Radius

Now that you have the rad CLI installed, you can initialize Radius. This will:

- Install the Radius Helm chart into your Kubernetes cluster
- Create a new Radius resource group on the cluster
- Create a new Radius environment on the cluster and install the local-dev Recipes into it
- Create a new Radius workspace on your local machine

Let's talk a little more about what each of these steps do.

### Installing the Radius Helm chart

Radius offers a Helm chart that can be used to install Radius into your Kubernetes cluster. For more information refer to the [Radius Helm chart source code](https://github.com/radius-project/radius/tree/main/deploy/Chart) and the [Radius Kubernetes installation docs]({{< ref "/guides/operations/kubernetes/kubernetes-install#install-with-helm" >}})

After installing the chart, the Radius control-plane will be running within the `radius-system` namespace on your Kubernetes cluster. For more information on these services and the Radius architecture, refer to the [architecture docs]({{< ref "/concepts/technical/architecture" >}}).

You can view the installed Helm chart by running the following:

```bash
helm status radius -n radius-system
```

You should see information about the chart:

```
NAME: radius
LAST DEPLOYED: Fri Dec  8 12:31:25 2023
NAMESPACE: radius-system
STATUS: deployed
REVISION: 1
TEST SUITE: None
NOTES:
CHART NAME: radius
CHART VERSION: 0.27.0
APP VERSION: 0.27.0

radius has been installed. Check its status by running:

  kubectl --namespace radius-system get pods -l "app.kubernetes.io/part-of=radius"

Visit https://docs.radapp.io to start Radius.
```

Note that the Radius control-plane is _not_ a Kubernetes operator (with the exception of one service, which is a separate _client_ of Radius. More on this later_). It is a set of services that offer a separate API for interacting with Radius resources. This API is exposed via the [Kubernetes API Aggregation Layer](https://kubernetes.io/docs/concepts/extend-kubernetes/api-extension/apiserver-aggregation/), and can be accessed via the `rad` CLI or the [Radius API]({{< ref "/concepts/technical/api" >}}).

#### Backing database

So where is my Radius data stored? The backing database for Radius is pluggable, but by default Kubernetes environments leverage Kubernetes CRDs as the backing database. This allows Radius to have a persistent database that is backed up by the Kubernetes cluster itself, without needing to run a separate database service.

If you want to see these CRDs in the namespace, just run `kubcetl get crds -n radius-system` and you'll see the Radius CRDs, among others:

```bash
kubectl get crd -n radius-system
```

You should see:

```
NAME                                          CREATED AT
recipes.radapp.io                             2023-12-08T20:31:25Z
queuemessages.ucp.dev                         2023-12-08T20:31:25Z
resources.ucp.dev                             2023-12-08T20:31:25Z
```

The first CRD, `recipes.radapp.io`, allows you to use Recipes from your existing YAML & Helm charts (_this is what the controller mentioned above is for. See the [Helm tutorial]({{< ref "/tutorials/helm" >}}) for more information._). The other two, `queuemessages.ucp.dev` and `resources.ucp.dev`, are used to store the state of your application and its resources, along with operations within Radius. Anytime you create a new resource, deploy an application, or run a recipe, Radius will store the state of that operation and the resource itself in these CRDs.

### Create a new Radius resource group

Radius offers [resource groups]({{< ref "/guides/operations/groups/overview" >}}) to help group resources together with similar lifecycles. For example, all the resources in an app would typically go into the same resource group. When Radius is initialized, it creates a new resource group called `default`.

If you want to see this resource group, run the following:

```bash
rad group show default -o json
```

You'll see the following output, showing the raw JSON payload from the API:

```
{
  "id": "/planes/radius/local/resourcegroups/default",
  "location": "global",
  "name": "default",
  "tags": {},
  "type": "System.Resources/resourceGroups"
}
```

### Create a new Radius environment and install local-dev Recipes

Next, Radius will create a [Radius environment]({{< ref "/guides/deploy-apps/environments/overview" >}}), which is used to configure the "landing zone" where applications are deployed.

When the environment is created, the [local-dev Recipes]({{< ref "/guides/recipes/howto-dev-recipes" >}}) will be installed into the environment. These are a set of lightweight, containerized Recipes that can be used to quickly deploy applications. Refer to the [Recipes repo](https://github.com/radius-project/recipes/tree/main/local-dev) to view these Recipes.

If you want to see this environment, run the following:

```bash
rad env show default -o json
```

You'll see the raw JSON response from the API, complete with the registered Recipes:

```
{
  "id": "/planes/radius/local/resourcegroups/default/providers/Applications.Core/environments/default",
  "location": "global",
  "name": "default",
  "properties": {
    "compute": {
      "kind": "kubernetes",
      "namespace": "default"
    },
    "provisioningState": "Succeeded",
    "recipes": {
      "Applications.Dapr/pubSubBrokers": {
        "default": {
          "plainHTTP": false,
          "templateKind": "bicep",
          "templatePath": "ghcr.io/radius-project/recipes/local-dev/pubsubbrokers:latest"
        }
      },
      "Applications.Dapr/secretStores": {
        "default": {
          "plainHTTP": false,
          "templateKind": "bicep",
          "templatePath": "ghcr.io/radius-project/recipes/local-dev/secretstores:latest"
        }
      },
      "Applications.Dapr/stateStores": {
        "default": {
          "plainHTTP": false,
          "templateKind": "bicep",
          "templatePath": "ghcr.io/radius-project/recipes/local-dev/statestores:latest"
        }
      },
      "Applications.Datastores/mongoDatabases": {
        "default": {
          "plainHTTP": false,
          "templateKind": "bicep",
          "templatePath": "ghcr.io/radius-project/recipes/local-dev/mongodatabases:latest"
        }
      },
      "Applications.Datastores/redisCaches": {
        "default": {
          "plainHTTP": false,
          "templateKind": "bicep",
          "templatePath": "ghcr.io/radius-project/recipes/local-dev/rediscaches:latest"
        }
      },
      "Applications.Datastores/sqlDatabases": {
        "default": {
          "plainHTTP": false,
          "templateKind": "bicep",
          "templatePath": "ghcr.io/radius-project/recipes/local-dev/sqldatabases:latest"
        }
      },
      "Applications.Messaging/rabbitMQQueues": {
        "default": {
          "plainHTTP": false,
          "templateKind": "bicep",
          "templatePath": "ghcr.io/radius-project/recipes/local-dev/rabbitmqqueues:latest"
        }
      }
    }
  },
  "systemData": {
    "createdAt": "0001-01-01T00:00:00Z",
    "createdBy": "",
    "createdByType": "",
    "lastModifiedAt": "0001-01-01T00:00:00Z",
    "lastModifiedBy": "",
    "lastModifiedByType": ""
  },
  "tags": {},
  "type": "Applications.Core/environments"
}
```

### Create a new workspace

A [workspace]({{< ref "/guides/operations/workspaces/overview" >}}) is a way to keep track of your clusters, groups, and environments on your local machine. Workspaces are tracked in the Radius `config.yaml` file, stored in the `~/.rad` directory on your local machine.

You can view your workspaces by running the following:

```bash
cat ~/.rad/config.yaml
```

You should see something like:

```
workspaces:
    default: default
    items:
        default:
            connection:
                context: k3d-k3s-default
                kind: kubernetes
            environment: /planes/radius/local/resourceGroups/default/providers/Applications.Core/environments/default
            scope: /planes/radius/local/resourceGroups/default
```

This shows that you have a workspace called `default`, which is connected to the `k3d-k3s-default` Kubernetes context, and is scoped to the `default` resource group and `default` environment. When you run commands with the `rad` CLI, it will use this workspace to determine which cluster, group, and environment to communicate with and use.

Note that the environment and scope fields leverage UCP IDs, which are used to uniquely identify resources within Radius. For more information on UCP IDs, refer to the [architecture docs]({{< ref "/concepts/technical/api#resource-ids" >}}).

## Deploy an application

Now, let's take a look at what happens when you deploy a Radius application, such as the one described in the getting started guide:

{{< rad file="snippets/app.bicep" embed="true" >}}

Running `rad deploy` will do the following:

1. Compile the Bicep file into its JSON template representation
1. Create a new deployment resource via the Radius API, with the compiled template as its contents
1. Wait for the deployment to complete, reporting status

Let's take a look at each of these steps.

### Compile the Bicep file

Radius currently uses a version of the [Bicep project](https://github.com/azure/bicep), which is an infrastructure-as-code language that offers an easy-to-use language that compiles down to ARM templates. The rad-bicep binary is used to compile Bicep files into their JSON template representation.

You can see the compiled template by running the following (_add .exe to rad-bicep if on Windows_):

```bash
~/.rad/bin/rad-bicep build app.bicep
cat app.json
```

You should see something like:

```
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "languageVersion": "1.9-experimental",
  "contentVersion": "1.0.0.0",
  "metadata": {
    "_EXPERIMENTAL_WARNING": "Symbolic name support in ARM is experimental, and should be enabled for testing purposes only. Do not enable this setting for any production usage, or you may be unexpectedly broken at any time!",
    "_generator": {
      "name": "bicep",
      "version": "0.0.0.6",
      "templateHash": "9056558733339908272"
    }
  },
  "parameters": {
    "application": {
      "type": "string",
      "metadata": {
        "description": "The app ID of your Radius Application. Set automatically by the rad CLI."
      }
    },
    "environment": {
      "type": "string",
      "metadata": {
        "description": "The environment ID of your Radius Application. Set automatically by the rad CLI."
      }
    }
  },
  "imports": {
    "radius": {
      "provider": "Radius",
      "version": "1.0"
    }
  },
  "resources": {
    "demo": {
      "import": "radius",
      "type": "Applications.Core/containers@2023-10-01-preview",
      "properties": {
        "name": "demo",
        "properties": {
          "application": "[parameters('application')]",
          "container": {
            "image": "ghcr.io/radius-project/samples/demo:latest",
            "ports": {
              "web": {
                "containerPort": 3000
              }
            }
          },
          "connections": {
            "redis": {
              "source": "[reference('db').id]"
            }
          }
        }
      },
      "dependsOn": [
        "db"
      ]
    },
    "db": {
      "import": "radius",
      "type": "Applications.Datastores/redisCaches@2023-10-01-preview",
      "properties": {
        "name": "db",
        "properties": {
          "application": "[parameters('application')]",
          "environment": "[parameters('environment')]"
        }
      }
    }
  }
}
```

### Create a deployment resource and wait for completion

Bicep deployments are handled by the `bicep-de` service in the Radius control-plane. Deployments are submitted as a new `Bicep.Deployments` resources. Refer to the [architecture docs]({{< ref "/concepts/technical/architecture#bicep-deployments-resource-provider" >}}) for more information.

The deployment engine breaks down all the resources in the JSON template and deploys/updates resources as needed, returning the status of the deployment as it progresses.

You can deploy your application with:

```bash
rad deploy app.bicep -a demo
```

Under the hood, Radius is turning containers into Kubernetes objects, and running any Recipes that are needed to provision the underlying infrastructure.

### View the application graph

Once complete, you can view the contents of your application with the following command:

```bash
rad app graph -a demo
```

You should see something like:

```
Displaying application: demo

Name: demo (Applications.Core/containers)
Connections:
  demo -> db (Applications.Datastores/redisCaches)
Resources:
  demo (kubernetes: apps/Deployment)
  demo (kubernetes: core/Secret)
  demo (kubernetes: core/Service)
  demo (kubernetes: core/ServiceAccount)
  demo (kubernetes: rbac.authorization.k8s.io/Role)
  demo (kubernetes: rbac.authorization.k8s.io/RoleBinding)

Name: db (Applications.Datastores/redisCaches)
Connections:
  demo (Applications.Core/containers) -> db
Resources:
  redis-r5tcrra3d7uh6 (kubernetes: apps/Deployment)
  redis-r5tcrra3d7uh6 (kubernetes: core/Service)
```

This graph shows every resource in the app, along with the underlying infrastructure running it.

### Verify Kubernetes objects

Let's take a look at what's actually running the application. Run the following command to see the Kubernetes objects that were created:

```bash
kubectl get all -n default-demo
```

Note that the Kubernetes namespace used for application deployments is `<envNamespace>-<appName>`. In this case, the environment namespace is `default` and the application ID is `demo`, so the namespace is `default-demo`.

You should see something like:

```
kubectl get all -n default-demo
NAME                                     READY   STATUS    RESTARTS   AGE
pod/redis-r5tcrra3d7uh6-7679cd55-24tl4   2/2     Running   0          18m
pod/demo-56f7cd6c88-nwdq6                1/1     Running   0          17m

NAME                          TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)    AGE
service/redis-r5tcrra3d7uh6   ClusterIP   10.43.144.48   <none>        6379/TCP   18m
service/demo                  ClusterIP   10.43.57.59    <none>        3000/TCP   16m

NAME                                  READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/redis-r5tcrra3d7uh6   1/1     1            1           18m
deployment.apps/demo                  1/1     1            1           17m

NAME                                           DESIRED   CURRENT   READY   AGE
replicaset.apps/redis-r5tcrra3d7uh6-7679cd55   1         1         1       18m
replicaset.apps/demo-56f7cd6c88                1         1         1       17m
```

For more information on how Radius containers are mapped to Kubernetes objects, refer to the [Kubernetes docs]({{< ref "/guides/operations/kubernetes/overview#resource-mapping" >}}). For more information on the Redis local-dev Recipe that created the underlying Redis Kubernetes objects, refer to the [Recipe source template](https://github.com/radius-project/recipes/blob/main/local-dev/rediscaches.bicep).

### Verify the application connections

When a container connects to another resource, Radius will automatically create the necessary connections between the two resources. In the above example, this means setting environment variables on the `demo` container with the connection information for the `db` container.

You can verify this by running the following:

```bash
kubectl get deployment demo -n default-demo -o jsonpath='{.spec.template.spec.containers[0].env}'
```

You should see something like:

```
[
    {
        "name":"CONNECTION_REDIS_CONNECTIONSTRING",
        "valueFrom":{"secretKeyRef":{"key":"CONNECTION_REDIS_CONNECTIONSTRING","name":"demo"}}
    },
    {
        "name":"CONNECTION_REDIS_HOST",
        "valueFrom":{"secretKeyRef":{"key":"CONNECTION_REDIS_HOST","name":"demo"}}
    },
    {
        "name":"CONNECTION_REDIS_PORT",
        "valueFrom":{"secretKeyRef":{"key":"CONNECTION_REDIS_PORT","name":"demo"}}
    },
    {
        "name":"CONNECTION_REDIS_URL",
        "valueFrom":{"secretKeyRef":{"key":"CONNECTION_REDIS_URL","name":"demo"}}
    }
]
```

Radius has automatically configured the backing secrets and values for the `demo` container to connect to the `db` container, which you can use from your code.

## Cleanup

To clean up your application, run the following:

```bash
rad app delete demo -y
```

This command will first delete any resources within the application, then delete the application itself. Any resources deployed via the Recipe will also be deleted.

## Done

You're done! We hope this walkthrough helped you understand how Radius works and what happens when you use Radius to deploy applications. If you have any questions, feel free to reach out to us on [Discord](https://aka.ms/radius/discord).
