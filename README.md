# Nix Configuration

This repository contains my personal Nix configuration files for managing system packages, development environments, and dotfiles.

## Installation

### 1. Install Nix

First, install the Nix package manager:

```shell
sh <(curl -L https://nixos.org/nix/install)
```

### 2. Clone and Apply Configuration

Clone this repository and apply the configuration:

```shell
git clone https://github.com/ak9024/nix.git
cd nix
nix run nix-darwin -- switch --flake ~/nix#m2
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
