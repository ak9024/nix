{ config, lib, pkgs, inputs, ... }:

{
  # Import the sops module from inputs
  imports = [ inputs.sops-nix.darwinModules.sops ];
  
  # Setup sops-nix for secret management
  sops = {
    # Path to the encrypted secrets file
    defaultSopsFile = ./secrets.yaml;
    
    # Define the secrets
    secrets.anthropic-api-key = {
      # This defines where the decrypted secret will be mounted
      path = "/run/secrets/anthropic-api-key";
      mode = "0400";
      owner = "ak9024";
    };
  };
  
  # Make the secrets available as environment variables
  environment.variables = {
    # This will reference the file path, not the actual secret value
    ANTHROPIC_API_KEY = config.sops.secrets.anthropic-api-key.path;
  };
  
  # Make sops-related tools available
  environment.systemPackages = with pkgs; [
    sops
    age
    gnupg
  ];

  # AGE key configuration - specify the default age key
  sops.age.keyFile = "/Users/ak9024/.config/sops/age/keys.txt";
  #
  # # Ensure proper activation for secret management
  # system.activationScripts.postActivation.text = ''
  #   # Ensure AGE key directory exists
  #   mkdir -p /Users/ak9024/.config/sops/age
  #   chown ak9024:staff /Users/ak9024/.config/sops/age
  #   chmod 700 /Users/ak9024/.config/sops/age
  #
  #   # Ensure run/secrets directory has correct permissions
  #   mkdir -p /run/secrets
  #   chmod 755 /run/secrets
  #
  #   # Remind user of GPG key import if needed
  #   if ! gpg --list-keys "5EE4B4AA847D7581E4FB2CBF4FC14A6093259FBA" > /dev/null 2>&1; then
  #     echo "WARNING: GPG key 5EE4B4AA847D7581E4FB2CBF4FC14A6093259FBA not found."
  #     echo "Please import your GPG key: gpg --import your-private-key.asc"
  #   fi
  # '';
}
