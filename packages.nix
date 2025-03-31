{ pkgs, ... }: 

{
  # List packages installed in system profile
  environment.systemPackages = with pkgs; [
    # Shell and terminal utilities
    oh-my-zsh
    neovim
    tmux
    fzf-zsh
    
    # Version control
    git
    delta
    
    # ZSH enhancements
    zsh-autosuggestions
    zsh-syntax-highlighting
    zsh-completions
    zsh-history-substring-search
    
    # Container tools
    colima
    docker_26
    minikube
    k9s
    
    # Programming languages and build tools
    cargo
    rustc
    cmake
    openssl
    pkg-config
    go
    nodejs_23
    
    # System utilities
    tldr
    wget
    htop
    jq
  ];
}
