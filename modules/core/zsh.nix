{ pkgs, config, ... }: 

{
  # ZSH Configuration
  # This module enables and configures ZSH with Oh My Zsh integration and Pure prompt
  programs.zsh = {
    enable = true;                  # Enable ZSH as a supported shell
    enableGlobalCompInit = true;    # Initialize the completion system globally
    enableCompletion = true;        # Enable ZSH's built-in completion system
    
    promptInit = ''
      # Oh My Zsh Configuration
      # Only load Oh My Zsh if it's installed in the user's home directory
      if [ -d "$HOME/.oh-my-zsh" ]; then
        export ZSH="$HOME/.oh-my-zsh"  # Set the path to Oh My Zsh installation directory
        ZSH_THEME=""                   # Disable default theme to avoid conflicts with Pure prompt
        plugins=(git docker docker-compose)  # Enable useful development plugins
        source $ZSH/oh-my-zsh.sh       # Load Oh My Zsh with the configured settings
      fi

      export ANTHROPIC_API_KEY=$(cat ${config.sops.secrets.anthropic-api-key.path});

      # Useful Aliases
      alias vi="nvim";                 # Use neovim as the default vi editor
      alias l="eza --long --total-size";  # Enhanced ls command with detailed view and size totals
      alias d="docker";                # Shorthand for docker commands

      # Pure Prompt Configuration
      # https://github.com/sindresorhus/pure
      autoload -U promptinit; promptinit

      # Pure Prompt Settings
      PURE_CMD_MAX_EXEC_TIME=10        # Show execution time for commands that take longer than 10 seconds

      # Pure Prompt Styling
      zstyle :prompt:pure:path color white            # Set path color to white
      zstyle ':prompt:pure:prompt:*' color cyan       # Set prompt symbols to cyan
      zstyle :prompt:pure:git:stash show yes          # Show git stash indicator when stashes exist

      # Activate Pure prompt
      prompt pure

      export GPG_TTY=$(tty)
    '';
  };
}
