---
type: docs
title: "Getting started with Radius: Run your first app using CDK"
linkTitle: "Getting started with CDK"
weight: 10
description: "Take a tour of Radius by getting started with your first app using the CDK. With the CDK you can describe and configure your application using programming languages like TypeScript or Python."
---

This tutorial is **only** supported using codespaces. Make sure you're using a codespace because this currently requires a custom build of Radius.

**Estimated time to complete: 10 min**

{{< image src="diagram.png" alt="Diagram of the application and its resources" width="500px" >}}

{{< alert title="🚀 Run in a <b>free</b> GitHub Codespace" color="primary" >}}
The Radius getting-started guide can be [run **for free** in a GitHub Codespace](https://github.blog/changelog/2022-11-09-codespaces-for-free-and-pro-accounts/). Visit the following link to get started in seconds:

[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://github.com/codespaces/new/radius-project/samples?skip_quickstart=true&machine=premiumLinux&repo=482051978&ref=rynowak%2Fexperiment&devcontainer_path=.devcontainer%2Fdevcontainer.json&geo=UsWest)
{{< /alert >}}

This tutorial introduces the [CDK](https://cdk.dev) to describe the configuration of an application using [TypeScript](https://www.typescriptlang.org/). Radius integrates with CDK so developers can work in languages they already use like Python, TypeScript, Java, and others. Using a general-purpose language to configure applications and share templates enables developers and organizations to work with tools like already know and use. 

In this tutorial you will:

- Use CDK and TypeScript to deploy an existing TODO application with a Redis Cache database.
- Use a Radius Recipe to create the Redis Cache database in your environment.
- Refactor the application description into a reusable template that can be shared with others.

## 3. Initialize Radius

Create a new directory for your app and navigate into it:

```bash
mkdir firstapp
cd firstapp
```

Initialize Radius. For this example, accept all the default options (press ENTER to confirm): 

```bash
rad init
```

You will be asked:

- `Setup application in the current directory?`: choose YES (default)
- `Select the configuration language`: choose `TypeScript (CDK` (default)

Example output:

```
Initializing Radius...                     

✅ Install Radius {{< param version >}}               
    - Kubernetes cluster: k3d-k3s-default   
    - Kubernetes namespace: radius-system   
✅ Create new environment default          
    - Kubernetes namespace: default 
    - Recipe pack: local-dev        
✅ Scaffold application firstapp using TypeScript (CDK)
   - Create app.ts
   - Create package.json
   - Create package-lock.json
   - Create .rad/rad.yaml
✅ Update local configuration              

Initialization complete! Have a RAD time 😎
```

In addition to starting Radius services in your Kubernetes cluster, this initialization command creates a default application (`app.ts`) as your starting point. It contains a single container definition (`webapp`). 

```ts
import { ApplicationStack, ContainerResource, RedisCacheResource } from "rad-cdk";

const stack = ApplicationStack.createDefault("firstapp");

// Add more resources here to include them in the application.

// Update here to configure a container.
new ContainerResource(stack, "webapp", {
  properties: {
    container: {
      image: "ghcr.io/radius-project/samples/demo:latest",
      ports: {
        web: {
          containerPort: 3000,
        }
      }
    }
  }
});
stack.writeTemplate();
```

> This file will run the `ghcr.io/radius-project/samples/demo:latest` image. This image is published by the Radius team to a public registry, you do not need to create it.

{{< alert title="🚀🤯🚀 Explaining the code" color="primary" >}}
**What does this code do?**

The statement `const stack = ApplicationStack.createDefault("firstapp");` defines a new *stack* for an application called `firstapp`. Stacks allow you to manage the lifecycle of a set of resources as a group. Using stacks you can deploy resources, perform rollbacks and upgrades, or delete the stack. The `ApplicationStack` class should be used when the stack contains a single application.

The statement `new ContainerResource(stack, "webapp", { ... });` defines a container resource named `webapp` as part of the stack. The 3rd parameter is used to configure the behavior of the container. Many resources have required configuration, in this case the image to run is required.

Lastly `stack.writeTemplate();` is a required piece of plumbing. The `rad` CLI will use the written template to deploy the stack.
{{< /alert >}}

## 4. Run the app

Use the below command to run the app in your environment, then access the application by opening [http://localhost:3000](http://localhost:3000) in a browser.

**Since you are running in Codespaces, a new browser tab will launch automatically. If this does not happen check your popup-blocker.**

```bash
rad run app.ts
```

This command:

- Runs the application in your Kubernetes cluster
- Creates a port-forward from localhost to port 3000 inside the container so you can navigate to the app's frontend UI
- Streams container logs to your terminal

In your browser you should see the demo app:

{{< image src="demo-screenshot.png" alt="Screenshot of the demo container" width=600px >}}
<br /><br />

Congrats! You're running your first Radius app. When you're ready to move on to the next step, use <kbd>CTRL</kbd>+ <kbd>C</kbd> to exit the command.

{{< alert title="🚀🤯🚀 How it works" color="primary" >}}
**When you launch `rad run app.ts` at the command-line, how does it work?**

First the `rad` CLI will execute `app.ts` using Node.js. This means what the code you write inside `app.ts` will run locally prior to the application being deployed. You can use libraries to script additional build steps or write your own configuration logic to build the *stack* that gets deployed. At the end of execution any *stacks* that you have defined will be written to disk in a temporary location. 

Afterwards the `rad` CLI will read the output written during the execution of `app.ts` and use those *stacks* to deploy. Your code is not directly deploying cloud resources as it executes, instead it outputs a declarative template. This is helpful because Radius can implement advanced operations like *rollbacks* or *what-if* based on the template.
{{< /alert >}}


## 5. Add Database

This step will add a database (Redis Cache) to the application.

You can create a Redis Cache using [Recipes]({{< ref "guides/recipes/overview" >}}) provided by Radius. The Radius community provides Recipes for running commonly used application dependencies, including Redis.

In this step you will:

- Add Redis to the application using a Recipe.
- Connect to Redis from the `webapp` container using environment variables that Radius automatically sets.

Open `app.bicep` in your editor and get ready to edit the file.

First add some new code to `app.ts` by pasting in the content provided below. This should go between the comment that says `// Add more resources here to include them in the application.` and `new ContainerResource(...)`.

```ts
// Add more resources here to include them in the application.
const db = new RedisCacheResource(stack, "db")
```

Next, update your container definition to include `connections` inside `properties` (below `container`). This code creates a connection between the container and the database. Based on this connection, Radius will [inject environment variables]({{< ref "/guides/author-apps/containers/overview#connections" >}}) into the container that inform the container how to connect. You will view these in the next step.

```ts
new ContainerResource(stack, "webapp", {
  properties: {
    container: {
      // Existing code here
    },
    connections: {
      redis: {
        source: db.id,
      }
    }
  }
});
```

Your updated `app.bicep` will look like this:

```ts
import { ApplicationStack, ContainerResource, RedisCacheResource } from "rad-cdk";

const stack = ApplicationStack.createDefault("firstapp");

// Add more resources here to include them in the application.
const db = new RedisCacheResource(stack, "db")

// Update here to configure a container.
new ContainerResource(stack, "webapp", {
  properties: {
    container: {
      image: "ghcr.io/radius-project/samples/demo:latest",
      ports: {
        web: {
          containerPort: 3000,
        }
      }
    },
    connections: {
      redis: {
        source: db.id,
      }
    }
  }
});
stack.writeTemplate();
```

## 6. Rerun the application with a database

Use the command below to run the updated application again, then open the browser to [http://localhost:3000](http://localhost:3000).

```sh
rad run app.ts
```

You should see the Radius Connections section with new environment variables added. The `container` container now has connection information for Redis (`CONNECTION_REDIS_HOST`, `CONNECTION_REDIS_PORT`, etc.):

{{< image src="demo-with-redis-screenshot.png" alt="Screenshot of the webapp container" width=800px >}}
<br /><br />

Navigate to the Todo List tab and test out the application. Using the Todo page will update the saved state in Redis:

{{< image src="./images/demo-with-todolist.png" alt="Screenshot of the todolist" width=700px >}}
<br /><br />

Press <kbd>CTRL</kbd>+ <kbd>C</kbd> when you are finished with the website.

## 7. View the application graph

Radius Connections are more than just environment variables and configuration. You can also access the "application graph" and understand the connections within your application with the following command:

```bash
rad app graph
```

You should see the following output, detailing the connections between the `webapp` container and the `db` Redis Cache, along with information about the underlying Kubernetes resources running the app:

```
Displaying application: firstapp

Name: webapp (Applications.Core/containers)
Connections:
  webapp -> db (Applications.Datastores/redisCaches)
Resources:
  webapp (kubernetes: apps/Deployment)
  webapp (kubernetes: core/Secret)
  webapp (kubernetes: core/Service)
  webapp (kubernetes: core/ServiceAccount)
  webapp (kubernetes: rbac.authorization.k8s.io/Role)
  webapp (kubernetes: rbac.authorization.k8s.io/RoleBinding)

Name: db (Applications.Datastores/redisCaches)
Connections:
  webapp (Applications.Core/containers) -> db
Resources:
  redis-r5tcrra3d7uh6 (kubernetes: apps/Deployment)
  redis-r5tcrra3d7uh6 (kubernetes: core/Service)
```

## 8. Defining a "golden template"

In this step you will refactor the application into a reusable *"golden template"*. Since the CDK works with general-purpose programming languages, you can build and distribute your own abstractions using the package-managers and tools you already use. This pattern enables teams to colloborate more effectively, and for platform-engineers to simplify deployment and enforce standards.

To get started, create a new file called `webapp-template.ts`. You are going to gradually move the definitions from `app.ts` into this file.

Start by pasting the following structure into `webapp-template.ts`:

```ts
import { Construct } from "constructs";
import { ApplicationStack, ContainerResource, RedisCacheResource } from "rad-cdk";

/**
 * Defines configuration for the {@link Webapp} stack.
 */
export interface WebappConfig {
    // TODO: Add required and optional configuration properties here.
}

/**
 * Defines an application stack for a two-tiered web application, using
 * a container and a Redis cache.
 */
export class Webapp extends ApplicationStack {
    constructor(scope: Construct | undefined, id: string, config: WebappConfig) {
        super(scope, id);

        // TODO: Add more resources here to include them in the application.
    }
}
```

This code defines:

- A subclass of `ApplicationStack` (`Webapp`) that is specialized for two-tiered web applications (a golden template).
- A data type (`WebappConfig`) that exposes the supported configuration settings for the template.
- Documentation using JSDoc. This documentation will be available to users of the template.


Next, add a field to `WebappConfig` to allow users to set the container image. Replace the definition of `WebappConfig` in `webapp-template.ts` with the following code:

```ts
/**
 * Defines configuration for the {@link Webapp} stack.
 */
export interface WebappConfig {
    /**
     * The image to use for the container (required).
     */
    image: string;
}
```

After that, copy the resources (`RedisCacheResource` and `ContainerResource`) from `app.ts` into the constructor of `Webapp` in `webapp-template.ts` . Replace the line `// TODO: Add more resources here to include them in the application.`. When you paste this, you may see errors in the editor highlighting the `stack` variable (in two locations). Replace `stack` with `this`.

Last, remove the hardcoded image from `ContainerResource` and replace with `config.image`. This will allow users of the template to configure the image.

The final version of `webapp-template.ts` should look like the following:

```ts
import { Construct } from "constructs";
import { ApplicationStack, ContainerResource, RedisCacheResource } from "rad-cdk";

/**
 * Defines configuration for the {@link Webapp} stack.
 */
export interface WebappConfig {
  /**
   * The image to use for the container (required).
   */
  image: string;
}

/**
 * Defines an application stack for a two-tiered web application, using
 * a container and a Redis cache.
 */
export class Webapp extends ApplicationStack {
  constructor(scope: Construct | undefined, id: string, config: WebappConfig) {
    super(scope, id);

    const db = new RedisCacheResource(this, "db")

    // Update here to configure a container.
    new ContainerResource(this, "webapp", {
      properties: {
        container: {
          image: config.image,
          ports: {
            web: {
              containerPort: 3000,
            }
          }
        },
        connections: {
          redis: {
            source: db.id,
          }
        }
      }
    });
  }
}
```

## 9. Using a reusable "golden template"

Now that you have defined the reusable webapp template, you can simplify `app.ts`.

Replace the content of the file with the following text:

```ts
import { ApplicationStack } from "rad-cdk";
import { Webapp } from "./webapp-template";

const stack = ApplicationStack.create(Webapp, "sample", {
  image: "ghcr.io/radius-project/samples/demo:latest",
});
stack.writeTemplate();
```

You can try this out using `rad run app.ts`. The application will behave the same as the previous step.

```sh
rad run app.ts
```

{{< alert title="🚀🤯🚀 Why refactor?" color="primary" >}}
**Why build reusable templates?**

Building reusable templates like `webapp-template.ts` can help you share definitions using package-managers like NPM. This allows experts within the team and organization to simplify configuration and deployment tasks for others. For larger organizations with a platform-engineering approach, the platform engineers can provide and maintain the set of supported templates. This makes it easy to use the supported technologies and recommended practices. 

In this example you only defined the `image` of the container as configurable by the user. When creating a reusable template you get to decide which settings are configurable by the user, and which are defined and enforced by the template.  
{{< /alert >}}

## Recap and next steps

It's easy to build on the default app and add more resources to the app. 

To delete your app, see [rad app delete]({{< ref rad_application_delete >}}).

<br>
{{< button text="Next step: Radius Tutorials" page="tutorials" >}}
