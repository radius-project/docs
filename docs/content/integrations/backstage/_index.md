---
type: docs
title: "How to use the Radius plugin in Backstage"
linkTitle: "Use Radius in Backstage"
description: "Find, install, and configure the Radius plugin in an existing Backstage portal"
weight: 450
new_badge: true
---

The Radius plugin brings the Dashboard's resource views into an existing [Backstage](https://backstage.io/) portal. Your portal keeps its navigation, sign-in, and other plugins. You do not need to deploy a separate Dashboard to use these views.

## Find the plugin

Find the [Radius plugin source and README](https://github.com/radius-project/dashboard/tree/main/plugins/plugin-radius) in the [Dashboard repository](https://github.com/radius-project/dashboard). The steps below build the plugin from source and install its package archives in your Backstage portal.

## What you can view

The plugin has five list pages and three detail pages:

| Page | What it shows |
| --- | --- |
| Applications | Deployed Applications; open an Application to inspect its resources and live application graph. |
| Environments | Available Environments. |
| Environment details | Configuration, recipes, and resources for one Environment. |
| Recipes | Recipes available through Environment configuration and Recipe Packs. |
| Resources | Resources from the connected Radius control plane. |
| Resource details | Resource properties and JSON. Applications also have resources and graph tabs. |
| Resource Types | Registered Resource Types. |
| Resource Type details | Schema and documentation for a Resource Type. |

The application graph shows live resources and their connections.

All eight pages follow the host's light or dark theme within the Radius page. The plugin does not replace the host's navigation, Catalog, Settings, or global theme. Optional `ApplicationListInfoCard` and `EnvironmentListInfoCard` exports let the host add Radius lists to its home page.

## Before you begin

You need:

- A Kubernetes cluster with the [Radius control plane]({{< ref "/installation/control-plane" >}}) installed.
- A Backstage source checkout that you can build and configure.
- The host's Kubernetes frontend and backend plugins, with access to that cluster.
- React and ReactDOM 18.3.1.
- Node.js 24 and the Yarn version specified in the Dashboard root `package.json`.

Keep the host's existing authentication and access policy. Do not copy the standalone Dashboard's guest sign-in configuration into a shared portal.

## Step 1: Build the plugin package

Clone the Dashboard repository and build the plugin:

```bash
git clone https://github.com/radius-project/dashboard.git
cd dashboard || exit
yarn verify:shared-candidate vendor/shared-libraries/candidate.json
yarn install --immutable
yarn tsc
yarn workspace @internal/plugin-radius build
yarn workspace @internal/plugin-radius pack --out ../../radius-plugin.tgz
```

The last command writes `radius-plugin.tgz` at the repository root. The plugin uses two shared-library archives from `vendor/shared-libraries`. Use the archives listed in that directory's `candidate.json` file.

For source-build requirements, see [Building the Radius Dashboard](https://github.com/radius-project/dashboard/tree/main/docs/contributing/contributing-code/contributing-code-building).

## Step 2: Install the archives in your host

In your Backstage checkout, create a `vendor/radius` directory at the repository root. Copy these files from the Dashboard checkout into it:

- `radius-plugin.tgz`
- The archive named by `core.path` in `vendor/shared-libraries/candidate.json`. Name the copied file `core.tgz`.
- The archive named by `graphReact.path` in `vendor/shared-libraries/candidate.json`. Name the copied file `graph-react.tgz`.
- `vendor/shared-libraries/candidate.json`

Add the plugin to `dependencies` in the host's `packages/app/package.json`. Merge this entry with existing dependencies:

```json
{
  "dependencies": {
    "@internal/plugin-radius": "file:../../vendor/radius/radius-plugin.tgz"
  }
}
```

Merge the following entries into `resolutions` in the host's root `package.json`. These paths assume Yarn and the directory layout above:

```json
{
  "resolutions": {
    "@radius-project/core": "file:./vendor/radius/core.tgz",
    "@radius-project/graph-react": "file:./vendor/radius/graph-react.tgz"
  }
}
```

Run `yarn install` at the host root. Use one React and ReactDOM copy across the host and plugin. Resolve peer-dependency errors before continuing; do not force the installation into an incompatible host.

Keep the archives and updated host lockfile together so you can repeat the installation.

## Step 3: Register the frontend

Choose the entry that matches your host's frontend system. Do not register both.

### New frontend system

Import the `/alpha` entry and add it to the host's existing feature list. Keep the host's other features and route bindings:

```tsx
import { createApp } from '@backstage/frontend-defaults';
import radius from '@internal/plugin-radius/alpha';
import kubernetes from '@backstage/plugin-kubernetes/alpha';

const app = createApp({
  features: [
    radius,
    kubernetes,
    // Keep the host's other features here.
  ],
});

export default app.createRoot();
```

If the host already registers the Kubernetes feature, reuse it. The Radius entry supplies the API factory and all eight pages. It does not supply the host sidebar.

The default list paths are `/applications`, `/environments`, `/recipes`, `/resources`, and `/resource-types`. To avoid conflicts with host pages, mount all eight pages under `/radius` in the host's `app-config.yaml`:

```yaml
app:
  extensions:
    - page:radius/applications:
        config:
          path: /radius/applications
    - page:radius/environments:
        config:
          path: /radius/environments
    - page:radius/environment:
        config:
          path: /radius/environments/:group/:namespace/:type/:name
    - page:radius/recipes:
        config:
          path: /radius/recipes
    - page:radius/resources:
        config:
          path: /radius/resources
    - page:radius/resource:
        config:
          path: /radius/resources/:group/:namespace/:type/:name
    - page:radius/resource-types:
        config:
          path: /radius/resource-types
    - page:radius/resource-type:
        config:
          path: /radius/resource-types/:namespace/:typeName
```

Add navigation links in the host sidebar. Use `useRouteRef` from `@backstage/frontend-plugin-api` with `radius.routes.applications`, `environments`, `recipes`, `resources`, and `resourceTypes`. For example:

```tsx
import { useRouteRef } from '@backstage/frontend-plugin-api';
import radius from '@internal/plugin-radius/alpha';
import { Link } from 'react-router-dom';

function RadiusApplicationsLink() {
  const applications = useRouteRef(radius.routes.applications);
  if (!applications) {
    throw new Error('Missing Radius applications route');
  }
  return <Link to={applications()}>Radius Applications</Link>;
}
```

Route references keep links correct when the host changes the mount path. The [native host example](https://github.com/radius-project/dashboard/blob/main/plugins/plugin-radius/fixtures/native.tsx) also shows external route bindings and optional cards.

### Legacy frontend system

Use the root `@internal/plugin-radius` entry. Add the page exports to your existing `FlatRoutes` with the following paths. Keep the host's Kubernetes plugin registration and other routes:

| Export | Example route |
| --- | --- |
| `ApplicationListPage` | `/radius/applications` |
| `EnvironmentListPage` | `/radius/environments` |
| `EnvironmentPage` | `/radius/environments/:group/:namespace/:type/:name` |
| `RecipeListPage` | `/radius/recipes` |
| `ResourceListPage` | `/radius/resources` |
| `ResourcePage` | `/radius/resources/:group/:namespace/:type/:name` |
| `ResourceTypesListPage` | `/radius/resource-types` |
| `ResourceTypeDetailPage` | `/radius/resource-types/:namespace/:typeName` |

For example, inside the host's existing `FlatRoutes`:

```tsx
<Route path="/radius/applications" element={<ApplicationListPage />} />
```

Import `Route` from `react-router-dom` and the page exports from `@internal/plugin-radius`. Register all eight routes, not only the list pages. Use the exported route references for sidebar links. See the [complete legacy host example](https://github.com/radius-project/dashboard/blob/main/plugins/plugin-radius/fixtures/legacy.tsx).

## Step 4: Connect the Kubernetes backend

The plugin sends Radius resource reads and graph requests through the host's Backstage Kubernetes proxy to the Kubernetes API server. Radius is exposed through the Kubernetes API Aggregation Layer. The plugin needs no separate Radius backend plugin.

If your new-system backend does not already register the Kubernetes backend, add it to the existing backend composition after installing that Backstage dependency:

```ts
backend.add(import('@backstage/plugin-kubernetes-backend'));
```

Use the host's normal [Kubernetes configuration](https://backstage.io/docs/features/kubernetes/configuration/) and authentication policy. The backend must reach the cluster, and its configured cluster credentials need access to the Radius API. Graph retrieval uses POST as well as resource GET requests. Do not assume that access to the portal gives each user a separate Radius authorization boundary.

For **local evaluation only**, run `kubectl proxy` on the same machine as the Backstage backend. Check that the current Kubernetes context selects your Radius cluster. Add this to the host's local configuration:

```yaml
kubernetes:
  serviceLocatorMethod:
    type: multiTenant
  clusterLocatorMethods:
    - type: localKubectlProxy
```

Do not expose the local proxy to other machines or use it as a production connection.

Configure one Kubernetes cluster for the default Radius client. It selects the **first configured Kubernetes cluster** and the `radius/local` plane once per API instance. Resource reads and graph requests use that same context. There is no connection picker.

Hosts that need a different client can override the public `radiusApiRef`. New-system hosts can use the named `radiusApiExtension` export from `/alpha`. A custom API must implement the `RadiusApi` contract; graph support uses its optional `getApplicationGraph` method. Without that method, the graph tab shows an unsupported-operation error rather than bypassing the override.

## Step 5: Check the result

Build and start your host with its normal commands, then sign in through its existing provider.

1. Follow the Radius sidebar links. Open each list page and a resource, Environment, and Resource Type detail page.
1. Open a deployed Application and select its graph tab. Check that resources and connections appear, zoom controls work, and resource links stay under your Radius mount path.
1. Switch the host between light and dark themes. Check that Radius pages change and other host pages keep their own appearance.
1. Verify that denied access produces a visible error. A partial list has a warning; do not treat it as a complete inventory.

If a page fails, check the browser request and the Backstage backend log. Check frontend registration for missing API factories, Kubernetes configuration for connection errors, and cluster permissions for denied requests. Do not disable host authentication to make a failed request succeed.

## Related links

- [Access the standalone Dashboard]({{< ref "/installation/dashboard" >}})
- [Radius plugin source and README](https://github.com/radius-project/dashboard/tree/main/plugins/plugin-radius)
- [Backstage Kubernetes configuration](https://backstage.io/docs/features/kubernetes/configuration/)
