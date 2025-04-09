{ config, pkgs, lib, ... }:

{
  imports = [
    # Core system packages and applications
    ./packages.nix
    # ZSH shell configuration and customization
    ./zsh.nix
    # System-wide font configuration and management
    ./fonts.nix
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
  
  programs.tmux = {
    enable = true;  # Enable the tmux terminal multiplexer
  };

  # SSH configuration for automatic key management
  services.openssh = {
    enable = true;
  };

  # System activation script to run commands during system activation
  system.activationScripts.postActivation.text = ''
    # Clone LazyVim starter if it doesn't exist
    if [ ! -d "$HOME/.config/nvim" ]; then
      echo "Setting up LazyVim..."
      ${pkgs.git}/bin/git clone https://github.com/LazyVim/starter "$HOME"/.config/nvim
    fi
  '';
}

