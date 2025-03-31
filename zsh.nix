{ pkgs, ... }: 

{
  # Enable alternative shell support in nix-darwin
  programs.zsh = {
    enable = true;                  # Enable ZSH as a supported shell
    enableFzfHistory = true;        # Enable fuzzy search in command history
    enableFzfCompletion = true;     # Enable fuzzy completion for commands and arguments
    enableSyntaxHighlighting = true; # Highlight commands as you type them
    enableGlobalCompInit = true;    # Initialize the completion system globally
    enableFzfGit = true;            # Enable fuzzy search for git commands and branches
    enableCompletion = true;        # Enable ZSH's built-in completion system
    
    promptInit = ''
    # Check if Oh My Zsh is installed, if not, use default settings
    if [ -d "$HOME/.oh-my-zsh" ]; then
      export ZSH="$HOME/.oh-my-zsh"  # Set the path to Oh My Zsh installation directory
      ZSH_THEME=""  # Disable default theme to avoid conflicts with starship/pure
      plugins=(git docker docker-compose)  # Enable plugins with proper syntax
      source $ZSH/oh-my-zsh.sh  # Load Oh My Zsh with the configured settings
    fi

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
}
