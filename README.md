# myshell

Framework for bash

- [Project details](#project-details)
  - [Core](#core)
  - [Modules](#modules)
    - [Help](#help)
    - [cloud](#cloud)
    - [Docker](#docker)
    - [k8s](#k8s)
    - [ssh](#ssh)
    - [bw](#bw)
    - [John](#john)
    - [Utils](#utils)
- [Requirements](#requirements)
- [How to use](#how-to-use)
  - [Bash](#bash)
  - [Powershell](#powershell)

## Project details:

You will use .bash_profile file (section 'how to use') to load this project and the two main sections:
- Core: Files for managing shell profile
- Modules: Section for tools

### Core

- Scripts folder:
  - Random password generator (handled by powershell, will be replaced by another language soon)
- Shells folder:
  - bash: 
    - aliases
    - functions
    - jobs
    - profiles
    - .bash_profile
    - .bashrc
  - pwsh: Containing pwsh environment (will be deprecated soon)

### Modules

- #### Help
- #### cloud
- #### Docker
- #### k8s
- #### ssh
- #### bw
- #### John
- #### Utils

## Requirements

- Basic packages ```` git file curl ````

Mainly tested on bash 5.2+.

## How to use

### Bash:

1. Backup your $HOME/.bash_profile if exists
2. Clone where you want, copy .bash_profile to your home and set $project_path. Then restart the current shell session.

````
git clone git@github.com:e-lemongrab/myshell.git
cp -rfv myshell/core/shells/bash/.bash_profile $HOME
sed -i 's|$HOME/Documents/myshell|'"$(pwd)"'/myshell|g' ~/.bash_profile
exec -l $SHELL
````

3. Run "checks" to list compatibility and "myshell" to get the available commands to use


### Powershell:

Once done the bash configuration, if you have "pwsh" installed, automatically will set the $PROFILE for powershell - $HOME/.config/powershell/Microsoft.PowerShell_profile.ps1

If you want to use this profile from Windows:

1. Install WSL2 distro
2. Edit $PROFILE (ex: code $PROFILE, from a powershell terminal) with content from content core/shells/pwsh/Microsoft.PowerShell_profile.ps1

Remember to set the value for section "VARIABLE DECLARATION":
- $global:distro=xxx
- $global:project_path=xxx (relative path from $HOME)