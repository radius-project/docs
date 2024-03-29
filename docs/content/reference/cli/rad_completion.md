---
type: docs
title: "rad completion CLI reference"
linkTitle: "rad completion"
slug: rad_completion
url: /reference/cli/rad_completion/
description: "Details on the rad completion Radius CLI command"
---
## rad completion

Generates shell completion scripts

```
rad completion [flags]
```

### Examples

```

	# Installing bash completion on macOS using homebrew
	## If running Bash 3.2 included with macOS
	brew install bash-completion
	## or, if running Bash 4.1+
	brew install bash-completion@2
	## Add the completion to your completion directory
	rad completion bash > $(brew --prefix)/etc/bash_completion.d/rad
	source ~/.bash_profile
	# Installing bash completion on Linux
	## If bash-completion is not installed on Linux, please install the 'bash-completion' package
	## via your distribution's package manager.
	## Load the rad completion code for bash into the current shell
	source <(rad completion bash)
	## Write bash completion code to a file and source if from .bash_profile
	rad completion bash > ~/.rad/completion.bash.inc
	printf "
	## rad shell completion
	source '$HOME/.rad/completion.bash.inc'
	" >> $HOME/.bash_profile
	source $HOME/.bash_profile
	# Installing zsh completion on macOS using homebrew
	## If zsh-completion is not installed on macOS, please install the 'zsh-completion' package
	brew install zsh-completions
	## Set the rad completion code for zsh[1] to autoload on startup
	rad completion zsh > "${fpath[1]}/_rad"
	source ~/.zshrc
	# Installing zsh completion on Linux
	## If zsh-completion is not installed on Linux, please install the 'zsh-completion' package
	## via your distribution's package manager.
	## Load the rad completion code for zsh into the current shell
	source <(rad completion zsh)
	# Set the rad completion code for zsh[1] to autoload on startup
	rad completion zsh > "${fpath[1]}/_rad"
	# Installing powershell completion on Windows
	## Create $PROFILE if it not exists
	if (!(Test-Path -Path $PROFILE )){ New-Item -Type File -Path $PROFILE -Force }
	## Add the completion to your profile
	rad completion powershell >> $PROFILE

```

### Options

```
  -h, --help   help for completion
```

### Options inherited from parent commands

```
      --config string   config file (default "$HOME/.rad/config.yaml")
  -o, --output string   output format (supported formats are json, table) (default "table")
```

### SEE ALSO

* [rad]({{< ref rad.md >}})	 - Radius CLI
* [rad completion bash]({{< ref rad_completion_bash.md >}})	 - Generates bash completion scripts
* [rad completion powershell]({{< ref rad_completion_powershell.md >}})	 - Generates powershell completion scripts
* [rad completion zsh]({{< ref rad_completion_zsh.md >}})	 - Generates zsh completion scripts

