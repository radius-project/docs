Visual Studio Code offers the best authoring experience for Radius and Bicep. Download and install the Bicep extension to easily author and validate Bicep templates:

{{< alert title="Enable the official Bicep extension" color="warning" >}}
We previously released a version of the official Bicep extension specific to Radius called the Radius Bicep extension. We have since updated Radius to be compatible with the official Bicep extension. You can only have one VSCode Bicep extension installed at a time to build on Radius. If you have the Radius Bicep extension installed, you will need to uninstall it and use only the official Bicep extension.
{{< /alert >}}
{{< latest >}}
1. To install the Bicep extension, refer to their [installation documentation](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/install#visual-studio-code-and-bicep-extension)

1. Create a `bicepconfig.json` in your application's directory

In order to use the features provided by the Bicep extension with Radius, certain properties need to be defined. These are defined in a `bicepconfig.json` file that lives in your application's directory. `release-version` should correspond to the current release version in the form of `major.minor` (e.g. `0.36`).

```json
{
	"experimentalFeaturesEnabled": {
		"extensibility": true,
		"extensionRegistry": true,
		"dynamicTypeLoading": true
	},
	"extensions": {
		"radius": "br:biceptypes.azurecr.io/radius:<release-version>",
		"aws": "br:biceptypes.azurecr.io/aws:<release-version>"
	}
}
```
{{< /latest >}}