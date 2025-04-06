{ config, pkgs, lib, ... }:

{
    homebrew = {
      enable = true;                 # Enable Homebrew package manager integration
      onActivation = {
        autoUpdate = true;           # Automatically update Homebrew on activation
        cleanup = "zap";             # Remove all unmanaged Homebrew packages
        upgrade = true;              # Upgrade all managed Homebrew packages
      };

      brews = [                      # List of Homebrew packages to install
        # Shell utilities
        "pure"                       # Minimalist ZSH prompt
        "eza"                        # Modern replacement for 'ls' command
        "ripgrep"                    # Fast grep-like search tool
        "fzf"

        # Security and encryption
        "gnupg"                      # GNU Privacy Guard - encryption and signing tool
        "pinentry"                   # PIN or passphrase entry dialog for GnuPG
        "pinentry-mac"               # macOS-specific PIN entry program for GPG
        "age"                        # Simple, modern file encryption tool
        "mkcert"                     # Tool for creating locally-trusted development certificates

        # Development tools
        "kubectx"                    # Tool to switch between Kubernetes contexts
        "pnpm"
      ];

      casks = [];
    };
  }
