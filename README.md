# Nix Configuration

This repository contains my personal Nix configuration files for managing system packages, development environments, and dotfiles.

## Installation

### 1. Install Nix

First, install the Nix package manager:

```shell
sh <(curl -L https://nixos.org/nix/install)
```

> after install need to reboot your system, then run again

### 2. Clone and Apply Configuration

Clone this repository and apply the configuration:

```shell
git clone https://github.com/ak9024/nix.git
cd nix
nix run nix-darwin -- switch --flake ~/nix#m2
```

```shell
# generate new ssh-keys
https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent
```


```shell
# https://github.com/Mic92/sops-nix?tab=readme-ov-file#usage-example
# Set up sops-nix with age encryption
mkdir -p ~/.config/sops/age
age-keygen -o ~/.config/sops/age/keys.txt
nix-shell -p ssh-to-age --run "ssh-to-age -private-key -i ~/.ssh/id_ed25519 > ~/.config/sops/age/keys.txt"
# edit ./modules/secrets/.sops.yaml (update new age)
nix-shell -p ssh-to-age --run 'cat ~/.ssh/id_ed25519.pub | ssh-to-age'
EDITOR="nvim" sops updatekeys ./modules/secrets/secrets.yaml
```


```shell
# for still using lazyvim, but next need to porting this config to nix.
# https://www.lazyvim.org/installation
git clone https://github.com/LazyVim/starter ~/.config/nvim
```

```shell
# next need to add home-manager to set this config in nix
touch ~/.gitconfig
```

```shell
# User identity configuration
[user]
signingkey = <signingkey>  # Your GPG key for signing commits
email = adiatma.mail@gmail.com
name = adiatma kamarudin

# Commit signing configuration
[commit]
gpgsign = true  # Enable GPG signing for all commits

# Core Git settings
[core]
pager = delta  # Use delta for improved diffs

# Interactive mode settings
[interactive]
difffilter = delta --color-only  # Use delta for interactive diffs

# Delta tool configuration
[delta]
navigate = true  # Enable navigation in delta

# Merge conflict resolution settings
[merge]
conflictstyle = zdiff3  # Use zdiff3 style for merge conflicts

# GPG configuration
[gpg]
program = /opt/homebrew/bin/gpg  # Path to GPG executable
```

### 3. Update Configuration

To update your system after making changes to the configuration:

```shell
darwin-rebuild switch --flake ~/nix#m2
```

## Features

- macOS system configuration using nix-darwin
- Reproducible development environments
- Declarative package management
