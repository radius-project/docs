1. Install a [GHCR-compatible Radius CLI release]({{< ref "/installation/cli#bicep-compatibility-for-ghcr" >}}) after that release and the public extension packages are available.

1. Create a new directory for your app and navigate into it:

    ```bash
    mkdir first-app
    cd first-app
    ```

1. Initialize Radius. Select `Yes` when asked to setup application in the current directory.  

    ```bash
    rad init
    ```

This generates a `bicepconfig.json` in your application's directory. Check it against the [GHCR extension configuration]({{< ref "/installation/dev-workstation#configure-bicepconfigjson" >}}), including OCI support. An OCI-capable compiler does not imply that the generated references already use GHCR; migrate any ACR references only after the release and publication prerequisites are satisfied.
