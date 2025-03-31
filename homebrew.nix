{ pkgs, ... }: 

{
  homebrew = {
    enable = true;                 # Enable Homebrew package manager integration
    onActivation = {
      autoUpdate = true;           # Automatically update Homebrew on activation
      cleanup = "zap";             # Remove all unmanaged Homebrew packages
      upgrade = true;              # Upgrade all managed Homebrew packages
    };
    brews = [                      # List of Homebrew packages to install
      "starship"                   # Cross-shell prompt customization
      "pure"                       # Minimalist ZSH prompt
      "pinentry"                   # PIN or passphrase entry dialog for GnuPG
      "gnupg"                      # GNU Privacy Guard - encryption and signing tool
      "pinentry-mac"               # macOS-specific PIN entry program for GPG
      "eza"
    ];
  };
}
