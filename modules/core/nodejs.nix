{ config, pkgs, lib, ... }:

{
  # Enable Node.js environment with global packages
  programs.node = {
    enable = true;
    package = pkgs.nodejs_23;  # Using Node.js 23 as specified in packages.nix
    enableNpm = true;  # Enable npm package manager
    
    # Global npm packages that should be available to all users
    npmPackages = [
      # Add your global npm packages here, for example:
      # "typescript"
      # "nodemon"
      # "pm2"
    ];
  };

  # Make sure node, npm and npx are available in the global PATH
  environment.systemPath = [
    "${config.programs.node.package}/bin"
  ];
  
  # Set Node.js related environment variables
  environment.variables = {
    # Specify the directory for global npm packages
    NODE_PATH = "${config.programs.node.package}/lib/node_modules";
    # Ensure npm global bin directory is in PATH
    PATH = lib.mkForce (lib.concatStringsSep ":" [
      "$HOME/.npm/bin"
      "$PATH"
    ]);
  };
}
