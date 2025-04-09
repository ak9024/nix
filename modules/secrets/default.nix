{ config, lib, pkgs, inputs, ... }:

{
  # Import sops-nix module for secret management
  # This module provides integration with sops for encrypted secrets in NixOS/nix-darwin
  imports = [ inputs.sops-nix.darwinModules.sops ];
  
  # Configure sops-nix for secure secret management
  sops = {
    # Path to the encrypted secrets file that contains all managed secrets
    defaultSopsFile = ./secrets.yaml;
    
    # SSH key to use for AGE decryption (GitHub SSH key)
    # This allows sops to use your existing SSH key for decryption
    age.sshKeyPaths = [];
    
    # Disable GPG SSH key paths as we're using AGE exclusively
    gnupg.sshKeyPaths = [];

    # Path to the AGE key file for decryption
    # This is where sops will look for the AGE private key
    age.keyFile = "/Users/ak9024/.config/sops/age/keys.txt";
    
    # Automatically generate an AGE key if one doesn't exist
    # This ensures the system can always decrypt secrets
    age.generateKey = true;

    # Secret definitions and their configuration
    secrets = {
      # Anthropic API key configuration
      anthropic-api-key = {
        # Mount path where the decrypted secret will be available
        path = "/run/secrets/anthropic-api-key";
        
        # File permissions: 0400 = read-only for owner
        mode = "0400";
        
        # User that owns the decrypted secret file
        owner = "ak9024";
      };
    };
  };
}

