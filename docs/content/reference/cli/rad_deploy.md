---
type: docs
title: "rad deploy CLI reference"
linkTitle: "rad deploy"
slug: rad_deploy
url: /reference/cli/rad_deploy/
description: "Details on the rad deploy Radius CLI command"
---
## rad deploy

Deploy a template

### Synopsis

Deploy a Bicep or ARM template
	
	The deploy command compiles a Bicep or ARM template and deploys it to your default environment (unless otherwise specified).
		
	You can combine Radius types as as well as other types that are available in Bicep such as Azure resources. See
	the Radius documentation for information about describing your application and resources with Bicep.
	
	You can specify parameters using the '--parameter' flag ('-p' for short). Parameters can be passed as:
	
	- A file containing multiple parameters using the ARM JSON parameter format (see below)
	- A file containing a single value in JSON format
	- A key-value-pair passed in the command line
	
	When passing multiple parameters in a single file, use the format described here:
	
		https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/parameter-files
	
	You can specify parameters using multiple sources. Parameters can be overridden based on the 
	order the are provided. Parameters appearing later in the argument list will override those defined earlier.
	

```
rad deploy [file] [flags]
```

### Examples

```

# deploy a Bicep template
rad deploy myapp.bicep

# deploy an ARM template (json)
rad deploy myapp.json

# deploy to a specific workspace
rad deploy myapp.bicep --workspace production

# deploy using a specific environment
rad deploy myapp.bicep --environment production

# deploy using a specific environment and resource group
rad deploy myapp.bicep --environment production --group mygroup

# specify a string parameter
rad deploy myapp.bicep --parameters version=latest


# specify a non-string parameter using a JSON file
rad deploy myapp.bicep --parameters configuration=@myfile.json


# specify many parameters using an ARM JSON parameter file
rad deploy myapp.bicep --parameters @myfile.json


# specify parameters from multiple sources
rad deploy myapp.bicep --parameters @myfile.json --parameters version=latest

```

### Options

```
  -a, --application string       The application name
  -e, --environment string       The environment name
  -g, --group string             The resource group name
  -h, --help                     help for deploy
  -p, --parameters stringArray   Specify parameters for the deployment
  -w, --workspace string         The workspace name
```

### Options inherited from parent commands

```
      --config string   config file (default "$HOME/.rad/config.yaml")
  -o, --output string   output format (supported formats are json, table) (default "table")
```

### SEE ALSO

* [rad]({{< ref rad.md >}})	 - Radius CLI

