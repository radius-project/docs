---
type: docs
title: "rad bicep generate-kubernetes-manifest CLI reference"
linkTitle: "rad bicep generate-kubernetes-manifest"
slug: rad_bicep_generate-kubernetes-manifest
url: /reference/cli/rad_bicep_generate-kubernetes-manifest/
description: "Details on the rad bicep generate-kubernetes-manifest Radius CLI command"
---
## rad bicep generate-kubernetes-manifest

Generate a DeploymentTemplate Custom Resource.

### Synopsis

Generate a DeploymentTemplate Custom Resource.

	This command compiles a Bicep template with the given parameters and outputs a DeploymentTemplate Custom Resource.

	You can specify parameters using the '--parameter' flag ('-p' for short). Parameters can be passed as:
	
	- A file containing multiple parameters using the ARM JSON parameter format (see below)
	- A file containing a single value in JSON format
	- A key-value-pair passed in the command line
	
	When passing multiple parameters in a single file, use the format described here:
	
		https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/parameter-files
	
	You can specify parameters using multiple sources. Parameters can be overridden based on the 
	order they are provided. Parameters appearing later in the argument list will override those defined earlier.
		

```
rad bicep generate-kubernetes-manifest [file] [flags]
```

### Examples

```

# Generate a DeploymentTemplate Custom Resource from a Bicep file.
rad bicep generate-kubernetes-manifest app.bicep --parameters @app.bicepparam --parameters tag=latest --destination-file app.yaml --resource-group default
		
```

### Options

```
      --aws-scope string          Scope for AWS deployment.
      --azure-scope string        Scope for Azure deployment.
  -d, --destination-file string   Path of the generated DeploymentTemplate yaml file created by running this command.
  -g, --group string              The resource group name
  -h, --help                      help for generate-kubernetes-manifest
  -p, --parameters stringArray    Specify parameters for the deployment
```

### Options inherited from parent commands

```
      --config string   config file (default "$HOME/.rad/config.yaml")
  -o, --output string   output format (supported formats are json, table) (default "table")
```

### SEE ALSO

* [rad bicep]({{< ref rad_bicep.md >}})	 - Handle bicep-specific tasks for Radius

