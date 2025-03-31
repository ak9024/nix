{ pkgs, ... }: 

{
  # Import other configuration files
  imports = [
    ./homebrew.nix    # Homebrew configuration
    ./fonts.nix       # Font configuration
    ./zsh.nix         # Zsh shell configuration
  ];

  # System-wide shell aliases
  environment.shellAliases = {
    ls = "eza --long --total-size";  # Replace standard ls with eza showing detailed file info and total size
    vi = "nvim .";                   # Open current directory in Neovim when typing 'vi'
    vim = "nvim";                    # Use neovim when typing vim
  };

  # Necessary for using flakes on this system
  nix.settings.experimental-features = "nix-command flakes";
  
  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 6;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";
}
