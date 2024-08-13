1. Install Radius CLI

{{< read file= "/shared-content/installation/rad-cli/install-rad-cli.md" >}}

1. Create a new directory for your app and navigate into it:

```bash
mkdir first-app
cd first-app
```

1. Initialize Radius. Select `Yes` when asked to setup application in the current directory.  

```bash
rad init
```

This will automatically generate a `bicepconfig.json` with the correct setup in your application's directory.