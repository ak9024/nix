{
  description = "ak9024's NixOS Darwin system configuration";

  inputs = {
    # Package sources - using unstable for latest packages
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    
    # Darwin system management framework
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs"; # Ensure consistent package versions
    };

    # Homebrew integration for managing macOS packages
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
   
    # Secret management with SOPS
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs"; # Ensure consistent package versions
    };
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, sops-nix, nix-homebrew }:
  {
    # Darwin configuration for M2 MacBook
    # Build with: darwin-rebuild switch --flake .#m2
    darwinConfigurations."m2" = nix-darwin.lib.darwinSystem {
      # System modules configuration
      modules = [
        ./modules/core      # Core system configuration (packages, settings)
        ./modules/secrets   # Secret management configuration (credentials, keys)
        ./modules/homebrew  # Homebrew packages and configuration

        # Homebrew integration via nix-homebrew module
        nix-homebrew.darwinModules.nix-homebrew
        {
          # Homebrew configuration settings
          nix-homebrew = {
            enable = true;       # Enable Homebrew management through Nix
            user = "ak9024";     # User account for Homebrew installation
            autoMigrate = true;  # Automatically migrate Homebrew on configuration changes
          };
        }
      ];
      # Pass flake inputs to all modules for access to sources and dependencies
      specialArgs = { inherit inputs; };
    };
  };
}

