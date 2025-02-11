---
type: docs
title: "rad bicep publish-extension CLI reference"
linkTitle: "rad bicep publish-extension"
slug: rad_bicep_publish-extension
url: /reference/cli/rad_bicep_publish-extension/
description: "Details on the rad bicep publish-extension Radius CLI command"
---
## rad bicep publish-extension

Generate or publish a Bicep extension for a set of resource types.

### Synopsis

Generate or publish a Bicep extension for a set of resource types.
This command compiles a set of resource types (resource provider manifest) into a Bicep extension for local use or distribution.

Bicep extensions enable extensibility for the Bicep language. This command can be used to generate and distribute Bicep support for resource types authored by users. Bicep extensions can be distributed using Open Container Initiative (OCI) registry, such as Azure Container Registry, Docker Hub, or GitHub Container Registry. See https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/bicep-extension for more information on Bicep extensions.

Once an extension is been generated, it can be used locally or published to a container registry for distribution depending on the target specified.

When publishing to an OCI registry it is expected the user runs docker login (or similar command) and has the proper permission to push to the target OCI registry.
		

```
rad bicep publish-extension [flags]
```

### Examples

```

# Generate a Bicep extension to a local file
rad bicep publish-extension --from-file ./Example.Provider.yaml --target ./output.tgz

# Publish a Bicep extension to a container registry
bicep publish-extension ./Example.Provider.yaml --target br:ghcr.io/myregistry/example-provider:v1
		
```

### Options

```
  -f, --from-file string   The input file. May be an absolute path or a path relative to the current working directory
  -h, --help               help for publish-extension
      --target string      The destination path file or OCI registry path. OCI registry paths use the format 'br:HOST/PATH:TAG'.
```

### Options inherited from parent commands

```
      --config string   config file (default "$HOME/.rad/config.yaml")
  -o, --output string   output format (supported formats are json, table) (default "table")
```

### SEE ALSO

* [rad bicep]({{< ref rad_bicep.md >}})	 - Handle bicep-specific tasks for Radius

