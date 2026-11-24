1. Install the Radius CLI for your application. Released 0.62 applications retain their [ACR configuration]({{< ref "/installation/dev-workstation#released-radius-062" >}}); development and future GHCR releases follow the [GHCR prerequisites]({{< ref "/installation/cli#bicep-compatibility-for-ghcr" >}}).

1. Create a new directory for your app and navigate into it:

    ```bash
    mkdir first-app
    cd first-app
    ```

1. Initialize Radius. Select `Yes` when asked to setup application in the current directory.  

    ```bash
    rad init
    ```

This generates a new `bicepconfig.json` for the installed CLI. Retain ACR references for the released 0.62 contract. A future release with GHCR defaults generates [GHCR references with OCI enabled]({{< ref "/installation/dev-workstation#configure-bicepconfigjson" >}}). Existing files are not overwritten; migrate them only when adopting that release's published contract, preserving explicit versions and custom extensions.
