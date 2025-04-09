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
nix run --experimental-features "nix-command flakes" nix-darwin -- switch --flake ~/nix#m2
```


```shell
# https://github.com/Mic92/sops-nix?tab=readme-ov-file#usage-example
# Set up sops-nix with age encryption
mkdir -p ~/.config/sops/age
age-keygen -o ~/.config/sops/age/keys.txt
nix-shell -p ssh-to-age --run "sudo ssh-to-age -private-key -i /var/root/.ssh/id_ed25519 > ~/.config/sops/age/keys.txt"
nix-shell -p ssh-to-age --run 'sudo cat /var/root/.ssh/id_ed25519.pub | ssh-to-age'
# edit ./modules/secrets/.sops.yaml (update new age)
cd ./modules/secrets/
EDITOR="nvim" sops secrets.yaml
```


```shell
# for still using lazyvim, but next need to porting this config to nix.
# https://www.lazyvim.org/installation
git clone https://github.com/LazyVim/starter ~/.config/nvim
```

# Generate a new GPG key

```shell
# Generate a new GPG key
gpg --full-generate-key
# Choose RSA and RSA (default)
# Set keysize to 4096 bits
# Set expiration as needed
# Enter your user information

# List your GPG keys to get the key ID
gpg --list-secret-keys --keyid-format=long
# Look for the line like: sec   rsa4096/ABC123DEF456GHI7 (your key ID is after the slash)

# Export your public key to add to GitHub/GitLab
gpg --armor --export ABC123DEF456GHI7

# Configure Git to use your key (replace with your actual key ID)
git config --global user.signingkey ABC123DEF456GHI7
git config --global commit.gpgsign true
git config --global gpg.program /opt/homebrew/bin/gpg
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
