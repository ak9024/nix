{ pkgs, ... }: 

{
  # List packages installed in system profile
  environment.systemPackages = with pkgs; [
    # Shell and terminal utilities
    oh-my-zsh
    neovim 
   
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
    podman
    podman-compose
    
    # Programming languages and build tools
    rustc
    cargo
    go
    nodejs_23
    go-migrate

    # System utilities
    tldr
    wget
    htop
    jq
    neofetch
    tree
    openssl
    cmake
    pkg-config
    sops
  ];
}
