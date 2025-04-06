{ config, pkgs, lib, ... }:

{
  imports = [
    # Core system packages and applications
    ./packages.nix
    # ZSH shell configuration and customization
    ./zsh.nix
    # System-wide font configuration and management
    ./fonts.nix
    # macOS Homebrew integration and package management
    ../homebrew
  ];

  # Nix package manager configuration
  nix = {
    # Enable flakes and nix-command for modern Nix workflows
    settings.experimental-features = [ "nix-command" "flakes" ];
  };

  # System state version - controls compatibility behaviors
  # Only change after reviewing: $ darwin-rebuild changelog
  system.stateVersion = 6;

  # Target platform specification for package compilation
  nixpkgs.hostPlatform = "aarch64-darwin";
  
  # macOS system settings and defaults
  system = {
    # Global macOS preferences and UI settings
    defaults = {
      NSGlobalDomain = {
        # Show all file extensions in Finder
        AppleShowAllExtensions = true;
        # Enable full keyboard access for all controls
        AppleKeyboardUIMode = 3;
      };
    };
    
    # System initialization scripts that run before activation
    activationScripts.preActivation.text = ''
      # Create and secure directory for sensitive files
      mkdir -p /run/secrets
      chmod 755 /run/secrets
      
      # Set up SSH configuration directory with proper permissions
      mkdir -p /etc/ssh
      chmod 755 /etc/ssh
    '';
  };

  # GPG and SSH agent configuration
  programs.gnupg = {
    # Enable GPG agent for key management
    agent.enable = true;
    # Use GPG agent for SSH authentication
    agent.enableSSHSupport = true;
  };

  programs.tmux = {
    enable = true;  # Enable the tmux terminal multiplexer
  };
}

