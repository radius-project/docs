1. Install a [Radius CLI release with GHCR defaults]({{< ref "/installation/cli#bicep-compatibility-for-ghcr" >}}) after that release and its corresponding public extension artifacts are available and verified.

1. Create a new directory for your app and navigate into it:

    ```bash
    mkdir first-app
    cd first-app
    ```

1. Initialize Radius. Select `Yes` when asked to setup application in the current directory.  

    ```bash
    rad init
    ```

With that release, this generates a new `bicepconfig.json` with [GHCR extension references and OCI support]({{< ref "/installation/dev-workstation#configure-bicepconfigjson" >}}) in your application's directory. Existing files are not overwritten; migrate their production ACR references only after the release and publication prerequisites are satisfied, preserving the selected release version and custom extensions.
