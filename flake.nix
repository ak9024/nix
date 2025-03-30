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
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, nix-homebrew }:
  let
    configuration = { pkgs, ... }: {
      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages = with pkgs;
        [ 
          oh-my-zsh
          neovim
          tmux
          fzf-zsh
          git
          colima
          docker_26
          delta
          zsh-autosuggestions
          zsh-syntax-highlighting
          zsh-completions
          zsh-history-substring-search
          cargo
          rustc
          cmake
          openssl
          pkg-config
        ];

      environment.shellAliases = {
        ls = "eza --long --total-size";  # Replace standard ls with eza showing detailed file info and total size
        vi = "nvim .";                   # Open current directory in Neovim when typing 'vi'
        vim = "nvim";                    # Use neovim when typing vim
      };

      # Configure system fonts
      fonts.packages = with pkgs; [
        # JetBrains Mono - a monospace font with programming ligatures
        nerd-fonts.jetbrains-mono
        # Fira Code - another popular monospace font with programming ligatures
        nerd-fonts.fira-code
      ];

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";
      
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

      # Enable alternative shell support in nix-darwin.
      programs.zsh = {
        enable = true;                  # Enable ZSH as a supported shell
        enableFzfHistory = true;        # Enable fuzzy search in command history
        enableFzfCompletion = true;     # Enable fuzzy completion for commands and arguments
        enableSyntaxHighlighting = true; # Highlight commands as you type them
        enableGlobalCompInit = true;    # Initialize the completion system globally
        enableFzfGit = true;            # Enable fuzzy search for git commands and branches
        enableCompletion = true;        # Enable ZSH's built-in completion system
        
        variables = {
          # API key for Anthropic's Claude AI service
          # Used for authentication when making requests to Anthropic's API
          ANTHROPIC_API_KEY = "";
        };

        promptInit = ''
        # Check if Oh My Zsh is installed, if not, use default settings
        if [ -d "$HOME/.oh-my-zsh" ]; then
          export ZSH="$HOME/.oh-my-zsh"  # Set the path to Oh My Zsh installation directory
          ZSH_THEME=""  # Disable default theme to avoid conflicts with starship/pure
          plugins=(git docker docker-compose)  # Enable plugins with proper syntax
          source $ZSH/oh-my-zsh.sh  # Load Oh My Zsh with the configured settings
        fi

        # Export the ANTHROPIC_API_KEY environment variable
        # This line takes the value from the system environment and makes it available in the shell
        export ANTHROPIC_API_KEY="${builtins.getEnv "ANTHROPIC_API_KEY"}";

        # Shell Prompt Configuration - Use starship as primary, fallback to pure
        if command -v starship &> /dev/null; then
          eval "$(starship init zsh)"     # Initialize Starship prompt
        elif command -v pure-prompt &> /dev/null || command -v prompt &> /dev/null; then
          # Initialize the Pure prompt system if available and starship isn't
          autoload -U promptinit
          promptinit
          prompt pure
        fi
        
        # Add autosuggestions if installed
        if [ -f ${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
          source ${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh
        fi
        '';
      };

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 6;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";
    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#m2
    darwinConfigurations."m2" = nix-darwin.lib.darwinSystem {
      modules = [
        # Main system configuration defined above
        configuration
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
    };

    # Export packages from the m2 configuration for use in other flakes
    darwinPackages = self.darwinConfigurations."m2".pkgs;
  };
}
