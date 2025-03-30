# Nix Configuration

This repository contains my personal Nix configuration files for managing system packages, development environments, and dotfiles.

```shell
sh <(curl -L https://nixos.org/nix/install)
```

```shell
git clone https://github.com/ak9024/nix.git;
cd nix;
nix run nix-darwin -- switch --flake ~/nix#m2;
```

```shell
darwin-rebuild switch --flake ~/nix#m2
```
