Initializing Radius installs the Radius control-plane and creates a Radius Environment. The control-plane is a set of services that provide the core functionality of Radius, running in the `radius-system` namespace.

1. Create a Kubernetes cluster

   Radius runs inside [Kubernetes]({{< ref "guides/operations/kubernetes" >}}). Create one from the [supported k8s clusters]({{< ref "/guides/operations/kubernetes/overview#supported-kubernetes-clusters" >}})
   > *If you don't have a preferred way to create Kubernetes clusters, you could try using [k3d](https://k3d.io/), which runs a minimal Kubernetes distribution in Docker.*

   Ensure your cluster is set as your current context:

   ```bash
   kubectl config current-context
   ```

1. Initialize a new [Radius Environment]({{< ref "/guides/deploy-apps/environments/overview">}}) with [`rad init`]({{< ref rad_init >}}):

   ```bash
   rad init
   ```

   Select `Yes` to setup the application in the current directory. This will create `app.bicep` and `bicepconfig.json` files

   ```
   Initializing Radius...

   🕔 Install Radius {{< param version >}}
      - Kubernetes cluster: kind
      - Kubernetes namespace: radius-system
   ⏳ Create new environment default
      - Kubernetes namespace: default
      - Recipe pack: local-dev
   ⏳ Scaffold application
   ⏳ Update local configuration
   ```

1. Verify the initialization by running:

   ```bash
   kubectl get deployments -n radius-system
   ```

   You should see:

   ```
   NAME                      READY   UP-TO-DATE   AVAILABLE   AGE
   applications-rp           1/1     1            1           53s
   bicep-de                  1/1     1            1           53s
   controller                1/1     1            1           53s
   ucp                       1/1     1            1           53s
   contour-contour           1/1     1            1           46s
   ```

   You can also use [`rad env list`]({{< ref rad_env_list.md >}}) to view your environment:

   ```bash
   rad env list
   ```
