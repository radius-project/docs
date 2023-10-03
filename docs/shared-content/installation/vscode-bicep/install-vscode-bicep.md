Visual Studio Code offers the best authoring experience for Radius and Bicep. Download and install the Radius Bicep extension to easily author and validate Bicep templates:

1. Download the latest extensions

   {{< tabs Links Terminal >}}

   {{% codetab %}}
   {{< button link="https://get.radapp.dev/tools/vscode-extensibility/stable/rad-vscode-bicep.vsix" text="Download Bicep extension" >}}

   {{< edge >}}
   {{< button link="https://get.radapp.dev/tools/vscode-extensibility/edge/rad-vscode-bicep.vsix" text="Download Bicep extension (edge)" >}}
   {{< /edge >}}
   {{% /codetab %}}

   {{% codetab %}}

   Stable Version

   ```bash
   curl https://get.radapp.dev/tools/vscode-extensibility/stable/rad-vscode-bicep.vsix --output rad-vscode-bicep.vsix
   ```

   Edge Version

   ```bash
   curl https://get.radapp.dev/tools/vscode-extensibility/edge/rad-vscode-bicep.vsix --output rad-vscode-bicep.vsix
   ```

   {{% /codetab %}}

   {{< /tabs >}}

2. Install the `.vsix` file:

   {{< tabs UI Terminal >}}

   {{% codetab %}}
   In VSCode, manually install the extension using the *Install from VSIX* command in the Extensions view command drop-down.

   <img src="/installation/vscode-bicep/images/vsix-install.png" alt="Screenshot of installing a vsix extension" width=400>
   

   {{% /codetab %}}

   {{% codetab %}}
   You can also import this extension on the [command-line](https://code.visualstudio.com/docs/editor/extension-gallery#_install-from-a-vsix) with:

   ```bash
   code --install-extension rad-vscode-bicep.vsix
   ```

   If you're on macOS, make sure to [setup the `code` alias](https://code.visualstudio.com/docs/setup/mac#_launching-from-the-command-line).

   {{% /codetab %}}

   {{< /tabs >}}

3. **Disable the official Bicep extension** if you have it installed. Do not install it if prompted, our custom extension needs to be responsible for handling `.bicep` files and you cannot have both extensions enabled at once.

4. If running on Windows Subsystem for Linux (WSL), make sure to install the extension in WSL as well:

   <img src="/installation/vscode-bicep/images/wsl-extension.png" alt="Screenshot of installing a vsix extension in WSL" width=400>
