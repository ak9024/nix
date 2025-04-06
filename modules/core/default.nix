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
  
  programs.tmux = {
    enable = true;  # Enable the tmux terminal multiplexer
  };

  environment.etc = {
    "gitconfig" = {
      text = ''
        [user]
          signingkey = 4fc14a6093259fba
          email = adiatma.mail@gmail.com
          name = adiatma kamarudin
        [commit]
          gpgsign = true
        [core]
          pager = delta
        [interactive]
          difffilter = delta --color-only
        [delta]
          navigate = true
        [merge]
          conflictstyle = zdiff3
        [gpg]
          program = /opt/homebrew/bin/gpg
      '';
    };
  };
}

