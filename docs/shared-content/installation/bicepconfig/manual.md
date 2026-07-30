1. Create a `bicepconfig.json` in your application's directory. `release-version` should correspond to the current release version in the form of `major.minor` (e.g. `0.36`). 

```json
{
    "extensions": {
        "radius": "br:biceptypes.azurecr.io/radius:<release-version>" 
	}
}
```
