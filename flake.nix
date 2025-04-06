{
  description = "ak9024 nix-darwin system flake";

  inputs = {
    # Main Nix package collection - using the unstable channel for latest packages
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    
    # Darwin system configuration framework
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    # Use the same nixpkgs instance for nix-darwin to ensure compatibility
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    # Integration for managing Homebrew packages through Nix
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
   
    # Integration with sops-nix to store secrets configuration
    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, sops-nix, nix-homebrew, }:
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#m2
    darwinConfigurations."m2" = nix-darwin.lib.darwinSystem {
      modules = [
        # Main system configuration
        # ./configuration.nix
        ./modules/core
        ./modules/secrets
        # Include the nix-homebrew module to manage Homebrew packages
        nix-homebrew.darwinModules.nix-homebrew
        # Configure nix-homebrew settings
        {
          nix-homebrew = {
            enable = true;              # Enable the nix-homebrew integration
            user = "ak9024";            # Specify the user for Homebrew installation
            autoMigrate = true;         # Automatically migrate Homebrew on changes
          };
        }
      ];
      specialArgs = { inherit inputs; };
    };
  };
}
