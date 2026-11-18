Use a [GHCR-compatible Radius release]({{< ref "/installation/cli#bicep-compatibility-for-ghcr" >}}) and wait until the public extension packages are available before switching an existing application.

1. Create a `bicepconfig.json` in your application's directory. For `<release-version>`, select the `major.minor` stable channel for that compatible Radius release, its full `major.minor.patch` version for a specific approved release, or the exact full prerelease version for a release candidate.

    ```json
    {
      "experimentalFeaturesEnabled": {
        "ociEnabled": true
      },
      "extensions": {
        "radius": "br:ghcr.io/radius-project/bicep-types-radius:<release-version>"
      }
    }
    ```

For development builds, use `edge`, not `latest`. Do not replace an unavailable release tag with a different channel or development tag. See [extension tag and digest semantics]({{< ref "/installation/dev-workstation#configure-bicepconfigjson" >}}) for release candidates, stable releases, and content pinning.

If an application or sample has its own `bicepconfig.json`, include `ociEnabled` in that file too.
