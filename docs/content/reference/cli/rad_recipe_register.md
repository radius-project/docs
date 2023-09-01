---
type: docs
title: "rad recipe register CLI reference"
linkTitle: "rad recipe register"
slug: rad_recipe_register
url: /reference/cli/rad_recipe_register/
description: "Details on the rad recipe register Radius CLI command"
---
## rad recipe register

Add a recipe to an environment.

### Synopsis

Add a recipe to an environment.
You can specify parameters using the '--parameter' flag ('-p' for short). Parameters can be passed as:
		
- A file containing a single value in JSON format
- A key-value-pair passed in the command line
		

```
rad recipe register [recipe-name] [flags]
```

### Examples

```

# Add a recipe to an environment
rad recipe register cosmosdb -e env_name -w workspace --template-kind bicep --template-path template_path --link-type Applications.Datastores/mongoDatabases
		
# Specify a parameter
rad recipe register cosmosdb -e env_name -w workspace --template-kind bicep --template-path template_path --link-type Applications.Datastores/mongoDatabases --parameters throughput=400
		
# specify multiple parameters using a JSON parameter file
rad recipe register cosmosdb -e env_name -w workspace --template-kind bicep --template-path template_path --link-type Applications.Datastores/mongoDatabases --parameters @myfile.json
		
```

### Options

```
  -e, --environment string        The environment name
  -g, --group string              The resource group name
  -h, --help                      help for register
      --link-type string          specify the type of the portable resource this recipe can be consumed by
  -o, --output string             output format (supported formats are json, table) (default "table")
  -p, --parameters stringArray    Specify parameters for the deployment
      --template-kind string      specify the kind for the template provided by the recipe.
      --template-path string      specify the path to the template provided by the recipe.
      --template-version string   specify the version for the terraform module.
  -w, --workspace string          The workspace name
```

### Options inherited from parent commands

```
      --config string   config file (default "$HOME/.rad/config.yaml")
```

### SEE ALSO

* [rad recipe]({{< ref rad_recipe.md >}})	 - Manage recipes

