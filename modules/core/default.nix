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


  services.openssh = {
    enable = true;
  };

  # Automatically generate SSH key on system activation
  system.activationScripts.postActivation.text = ''
    # Generate SSH key if it doesn't exist
    if [ ! -f "$HOME/.ssh/id_ed25519" ]; then
      mkdir -p "$HOME/.ssh"
      ssh-keygen -t ed25519 -C "adiatma.mail@gmail.com" -f "$HOME/.ssh/id_ed25519" -N ""
      echo "SSH key generated for adiatma.mail@gmail.com"
    fi

    # Ensure proper permissions
    chmod 700 "$HOME/.ssh"
    chmod 600 "$HOME/.ssh/id_ed25519"
    chmod 644 "$HOME/.ssh/id_ed25519.pub"
    
    # Add SSH key to SSH agent
    ssh-add "$HOME/.ssh/id_ed25519" 2>/dev/null || {
      eval "$(ssh-agent -s)" && ssh-add "$HOME/.ssh/id_ed25519"
    }
    
    # Print SSH key location
    # SSH keys are saved at /var/root/.ssh/id_ed25519
    echo "SSH keys are saved at: $HOME/.ssh/id_ed25519 (private key) and $HOME/.ssh/id_ed25519.pub (public key)"
  '';

}

