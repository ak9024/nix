{ config, lib, pkgs, inputs, ... }:

{
  # Import sops-nix module for secret management
  imports = [ inputs.sops-nix.darwinModules.sops ];
  
  # Configure sops-nix
  sops = {
    # Location of the encrypted secrets file
    defaultSopsFile = ./secrets.yaml;
    
    age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

    # AGE key configuration
    age.keyFile = "/Users/ak9024/.config/sops/age/keys.txt";
    
    age.generateKey = true;

    # Secret definitions
    secrets.anthropic-api-key = {
      # Mount path for the decrypted secret
      path = "/run/secrets/anthropic-api-key";
      # File permissions (read-only for owner)
      mode = "0400";
      # File ownership
      owner = "ak9024";
    };
  };
}

