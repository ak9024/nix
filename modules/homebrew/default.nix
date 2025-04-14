{ config, pkgs, lib, ... }:

{
    homebrew = {
      enable = true;                 # Enable Homebrew package manager integration
      
      # Configuration for what happens when the system is activated
      onActivation = {
        autoUpdate = true;           # Automatically update Homebrew formulae on activation
        cleanup = "zap";             # Remove all unmanaged Homebrew packages (most aggressive cleanup)
        upgrade = true;              # Upgrade all managed Homebrew packages to latest versions
      };

      # Command-line packages (formulae) to install via Homebrew
      brews = [
        # Shell utilities and enhancements
        "eza"                        # Modern, colorized replacement for 'ls' command
        "ripgrep"                    # Fast, regex-powered search tool (alternative to grep)
        "fzf"                        # Command-line fuzzy finder for files, history, and more

        # Security and encryption tools
        "gnupg"                      # GNU Privacy Guard - encryption, signing and key management
        "pinentry"                   # Secure dialog for entering PINs or passphrases
        "pinentry-mac"               # macOS-native PIN entry dialog for GPG
        "age"                        # Simple, modern and secure file encryption tool
        "mkcert"                     # Zero-config tool for creating locally-trusted development certificates

        # Development and Kubernetes tools
        "kubectx"                    # Tool for switching between Kubernetes contexts and namespaces
        "pnpm"                       # Fast, disk space efficient package manager for Node.js
      ];

      # GUI applications (casks) to install via Homebrew
      casks = [
        # Add GUI applications here as needed
      ];
    };
  }

