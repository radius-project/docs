The Radius control-plane is a set of services that provide the core functionality of Radius. It is deployed as a set of containers in a Kubernetes cluster.

1. Initialize a new [Radius environment]({{< ref "/guides/deploy-apps/environments/overview">}}) with [`rad init`]({{< ref rad_init >}}):
   ```bash
   rad init
   ```
   
   Select `Yes` to setup the app.bicep in the current directory

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

2. Verify the initialization by running:
   ```bash
   kubectl get deployments -n radius-system
   ```

   You should see:

   ```
   NAME                      READY   UP-TO-DATE   AVAILABLE   AGE
   ucp                       1/1     1            1           53s
   appcore-rp                1/1     1            1           53s
   bicep-de                  1/1     1            1           53s
   contour-contour           1/1     1            1           46s
   ```

   You can also use [`rad env list`]({{< ref rad_env_list.md >}}) to view your environment:
   
   ```bash
   rad env list
   ```