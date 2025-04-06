{ config, pkgs, lib, ... }:

{
  imports = [
    # Core packages and applications
    ./packages.nix
    # ZSH shell configuration
    ./zsh.nix
    # System fonts configuration
    ./fonts.nix
    # Homebrew integration for macOS
    ../homebrew
  ];

  # Nix configuration
  nix = {
    # Necessary for using flakes on this system
    settings.experimental-features = [ "nix-command" "flakes" ];
  };

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 6;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";
  
  # System settings
  system = {
    # Configure host name
    defaults = {
      NSGlobalDomain = {
        AppleShowAllExtensions = true;
        AppleKeyboardUIMode = 3;
      };
    };
    
    # Activation scripts
    activationScripts.preActivation.text = ''
      # Create directories for secrets and SSH keys
      mkdir -p /run/secrets
      chmod 755 /run/secrets
      
      # Ensure SSH directory exists with correct permissions
      mkdir -p /etc/ssh
      chmod 755 /etc/ssh
    '';
  };

  # GPG configuration
  programs.gnupg = {
    agent.enable = true;
    agent.enableSSHSupport = true;
  };
}
