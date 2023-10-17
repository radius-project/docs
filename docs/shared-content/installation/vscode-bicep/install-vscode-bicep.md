Visual Studio Code offers the best authoring experience for Radius and Bicep. Download and install the Radius Bicep extension to easily author and validate Bicep templates:

{{< alert title="Disable the official Bicep extension" color="warning" >}}
You can only have one VSCode Bicep extension installed at a time. To build on Radius, you will need to uninstall the official Bicep and use only the Radius Bicep extension.
{{< /alert >}}

1. To install the Radius Bicep extension, search for Radius Bicep in the Extensions tab in VSCode or in the [Visual Studio marketplace](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.rad-vscode-bicep&ssr=false#overview)

      <img src="/installation/vscode-bicep/images/radius-bicep.png" alt="Screenshot of Radius Bicep extension in VSCode Marketplace " width=500px>

2. Select Install

To verify you've installed the extension, open any file with the .bicep file extension and start [authoring Radius application]({{< ref author-apps >}}) to verify the auto-complete and other validation features.

{{< edge >}}
1. Visit the [GitHub Actions runs](https://github.com/radius-project/bicep/actions/workflows/radius-build.yml?query=event%3Apush+branch%3Abicep-extensibility)
2. Click on the latest successful run
3. Scroll down to Artifacts and download `release`
4. Extract the archive and Install the `rad-vscode-bicep.vsix` file:
   In VSCode, manually install the extension using the *Install from VSIX* command in the Extensions view command drop-down.

   <img src="/installation/vscode-bicep/images/vsix-install.png" alt="Screenshot of installing a vsix extension" width=400>
      
   You can also import this extension on the [command-line](https://code.visualstudio.com/docs/editor/extension-gallery#_install-from-a-vsix) with:

   ```bash
   code --install-extension rad-vscode-bicep.vsix
   ```
   If you're on macOS, make sure to [setup the `code` alias](https://code.visualstudio.com/docs/setup/mac#_launching-from-the-command-line).

5. If running on Windows Subsystem for Linux (WSL), make sure to install the extension in WSL as well:

   <img src="/installation/vscode-bicep/images/wsl-extension.png" alt="Screenshot of installing a vsix extension in WSL" width=400>
{{< /edge >}}
